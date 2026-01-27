#!/bin/bash

# Dotfiles restore script
# This script restores your dotfiles from the repository to your system

DOTFILES_DIR="$HOME/dotfiles"
HOME_DIR="$HOME"
CONFIG_DIR="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    echo -e "${YELLOW}Please clone the repository first:${NC}"
    echo "  git clone https://github.com/xentixar/dotfiles.git ~/dotfiles"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Dotfiles Restore Script              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Ask for restore method
echo -e "${YELLOW}Choose restore method:${NC}"
echo "  1) Create symlinks (recommended - keeps files in sync)"
echo "  2) Copy files (independent copies)"
read -p "Enter choice [1-2] (default: 1): " restore_method
restore_method=${restore_method:-1}

# Ask for backup existing files
echo ""
read -p "Backup existing files before restoring? [y/N]: " backup_existing
backup_existing=${backup_existing:-n}

# Create backup directory if needed
if [[ "$backup_existing" =~ ^[Yy]$ ]]; then
    BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    echo -e "${YELLOW}Backup directory: $BACKUP_DIR${NC}"
fi

# Function to backup file
backup_file() {
    local file=$1
    if [[ "$backup_existing" =~ ^[Yy]$ ]] && [ -e "$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp -r "$file" "$BACKUP_DIR/$file" 2>/dev/null
    fi
}

# Function to restore file
restore_file() {
    local source=$1
    local dest=$2
    
    if [ ! -e "$source" ]; then
        echo -e "  ${RED}✗${NC} Source not found: $source"
        return 1
    fi
    
    # Backup existing file
    backup_file "$dest"
    
    # Create parent directory
    mkdir -p "$(dirname "$dest")"
    
    # Remove existing file/directory
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi
    
    # Restore based on method
    if [ "$restore_method" = "1" ]; then
        # Create symlink
        ln -s "$source" "$dest"
        echo -e "  ${GREEN}✓${NC} Linked $dest → $source"
    else
        # Copy file
        cp -r "$source" "$dest"
        echo -e "  ${GREEN}✓${NC} Copied $dest"
    fi
}

# Restore dotfiles from home directory
echo ""
echo -e "${YELLOW}Restoring dotfiles from home directory...${NC}"
if [ -d "$DOTFILES_DIR/home" ]; then
    for file in "$DOTFILES_DIR/home"/.*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            restore_file "$file" "$HOME_DIR/$filename"
        fi
    done
else
    echo -e "  ${RED}✗${NC} home directory not found in dotfiles"
fi

# Restore config directories
echo ""
echo -e "${YELLOW}Restoring config directories...${NC}"
if [ -d "$DOTFILES_DIR/config" ]; then
    mkdir -p "$CONFIG_DIR"
    for dir in "$DOTFILES_DIR/config"/*; do
        if [ -d "$dir" ] || [ -f "$dir" ]; then
            dirname=$(basename "$dir")
            restore_file "$dir" "$CONFIG_DIR/$dirname"
        fi
    done
else
    echo -e "  ${RED}✗${NC} config directory not found in dotfiles"
fi

# Restore scripts
echo ""
echo -e "${YELLOW}Restoring scripts...${NC}"
if [ -d "$DOTFILES_DIR/scripts" ]; then
    restore_file "$DOTFILES_DIR/scripts" "$HOME_DIR/scripts"
elif [ -d "$DOTFILES_DIR/Scripts" ]; then
    # Fallback for capital S (legacy)
    restore_file "$DOTFILES_DIR/Scripts" "$HOME_DIR/Scripts"
else
    echo -e "  ${YELLOW}⚠${NC} Scripts directory not found (optional)"
fi

# Make scripts executable
if [ -d "$HOME_DIR/scripts" ]; then
    echo -e "${YELLOW}Making scripts executable...${NC}"
    find "$HOME_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Scripts are now executable"
elif [ -d "$HOME_DIR/Scripts" ]; then
    # Fallback for capital S (legacy)
    echo -e "${YELLOW}Making scripts executable...${NC}"
    find "$HOME_DIR/Scripts" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Scripts are now executable"
fi

# Source zshrc if using zsh
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
    echo ""
    echo -e "${YELLOW}Reloading zsh configuration...${NC}"
    source "$HOME/.zshrc" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} Zsh config reloaded"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Restore Completed Successfully!      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

if [[ "$backup_existing" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Backup saved to: $BACKUP_DIR${NC}"
fi

echo -e "${BLUE}Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Rebuild suckless tools (dwm, st, dmenu, slstatus) if needed"
echo "  3. Install any missing dependencies"

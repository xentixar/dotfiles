#!/bin/bash

# Dotfiles backup script
# This script copies your dotfiles to the dotfiles repository

DOTFILES_DIR="$HOME/dotfiles"
HOME_DIR="$HOME"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting dotfiles backup...${NC}"

# Create directories
mkdir -p "$DOTFILES_DIR/home"
mkdir -p "$DOTFILES_DIR/config"

# List of important dotfiles to backup (in home directory)
DOTFILES=(
    ".zshrc"
    ".zprofile"
    ".bashrc"
    ".bash_logout"
    ".profile"
)

# Copy dotfiles from home
echo -e "${YELLOW}Copying dotfiles from home directory...${NC}"
for file in "${DOTFILES[@]}"; do
    if [ -f "$HOME_DIR/$file" ]; then
        cp "$HOME_DIR/$file" "$DOTFILES_DIR/home/$file"
        echo -e "  ${GREEN}✓${NC} Copied $file"
    else
        echo -e "  ${RED}✗${NC} $file not found (skipping)"
    fi
done

# Copy important config directories
echo -e "${YELLOW}Copying config directories...${NC}"

# List of config directories to backup (selective)
CONFIG_DIRS=(
    "git"
    "nvim"
    "vim"
    "tmux"
    "alacritty"
    "i3"
    "polybar"
    "rofi"
    "zsh"
    "starship.toml"
    "dwm"
    "dmenu"
    "st"
    "slstatus"
    "emacs"
    "gtk-3.0"
    "gtk-4.0"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME_DIR/.config/$dir" ] || [ -f "$HOME_DIR/.config/$dir" ]; then
        mkdir -p "$DOTFILES_DIR/config/$(dirname "$dir")"
        cp -r "$HOME_DIR/.config/$dir" "$DOTFILES_DIR/config/$dir" 2>/dev/null
        if [ $? -eq 0 ]; then
            # Remove .git directories to avoid embedded repositories
            find "$DOTFILES_DIR/config/$dir" -name ".git" -type d -exec rm -rf {} + 2>/dev/null
            echo -e "  ${GREEN}✓${NC} Copied .config/$dir"
        fi
    fi
done

# Copy scripts if they exist
if [ -d "$HOME_DIR/Scripts" ]; then
    echo -e "${YELLOW}Copying scripts...${NC}"
    cp -r "$HOME_DIR/Scripts" "$DOTFILES_DIR/" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} Copied Scripts directory"
    fi
fi

echo -e "${GREEN}Backup completed!${NC}"
echo -e "${YELLOW}Review the files in $DOTFILES_DIR before committing.${NC}"

#!/bin/bash

# Complete system rebuild script
# Runs install.sh and restore.sh to fully rebuild the system

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Complete System Rebuild             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the dotfiles directory
if [ ! -f "$DOTFILES_DIR/restore.sh" ]; then
    echo -e "${RED}Error: restore.sh not found${NC}"
    echo "Please run this script from the dotfiles directory"
    exit 1
fi

# Step 1: Install dependencies
echo -e "${YELLOW}Step 1: Installing system dependencies...${NC}"
read -p "Run install.sh to install dependencies? [Y/n]: " run_install
run_install=${run_install:-y}

if [[ "$run_install" =~ ^[Yy]$ ]]; then
    bash "$DOTFILES_DIR/install.sh"
    echo ""
fi

# Step 2: Restore dotfiles
echo -e "${YELLOW}Step 2: Restoring dotfiles...${NC}"
read -p "Run restore.sh to restore dotfiles? [Y/n]: " run_restore
run_restore=${run_restore:-y}

if [[ "$run_restore" =~ ^[Yy]$ ]]; then
    bash "$DOTFILES_DIR/restore.sh"
    echo ""
fi

# Step 3: Rebuild suckless tools
echo -e "${YELLOW}Step 3: Rebuilding suckless tools...${NC}"
read -p "Rebuild suckless tools (dwm, st, dmenu, slstatus)? [y/N]: " rebuild_suckless

if [[ "$rebuild_suckless" =~ ^[Yy]$ ]]; then
    SUCKLESS_DIRS=("dwm" "st" "dmenu" "slstatus")
    
    for tool in "${SUCKLESS_DIRS[@]}"; do
        tool_dir="$HOME/.config/$tool"
        if [ -d "$tool_dir" ]; then
            echo -e "${YELLOW}Rebuilding $tool...${NC}"
            cd "$tool_dir"
            if [ -f "config.h" ] || [ -f "config.def.h" ]; then
                sudo make clean install 2>&1 | grep -E "(error|Error|✓|installed)" || echo -e "  ${GREEN}✓${NC} $tool rebuilt"
            else
                echo -e "  ${YELLOW}⚠${NC} $tool: config files not found, skipping"
            fi
            cd - > /dev/null
        else
            echo -e "  ${YELLOW}⚠${NC} $tool directory not found at $tool_dir"
        fi
    done
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   System Rebuild Completed!           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Final steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Log out and log back in to apply window manager changes"
echo "  3. Verify all configurations are working"

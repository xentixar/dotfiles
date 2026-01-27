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

# Step 3: Rebuild tools
echo -e "${YELLOW}Step 3: Rebuilding tools...${NC}"
read -p "Rebuild tools? [y/N]: " rebuild_tools

if [[ "$rebuild_tools" =~ ^[Yy]$ ]]; then
    if [ -f "$DOTFILES_DIR/build.sh" ]; then
        bash "$DOTFILES_DIR/build.sh"
    else
        echo -e "${YELLOW}⚠${NC} build.sh not found, using fallback method"
        BUILD_DIR="$DOTFILES_DIR/build"
        if [ -f "$BUILD_DIR/build_all.sh" ]; then
            bash "$BUILD_DIR/build_all.sh"
        else
            echo -e "${RED}✗${NC} build_all.sh not found"
        fi
    fi
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

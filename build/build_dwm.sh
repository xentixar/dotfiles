#!/bin/bash

# DWM Build Script
# Rebuilds dwm (Dynamic Window Manager)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   DWM Build Script                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

DWM_DIR="$HOME/.config/dwm"

# Check if dwm directory exists
if [ ! -d "$DWM_DIR" ]; then
    echo -e "${RED}✗${NC} DWM directory not found at $DWM_DIR"
    echo "Please restore dotfiles first: ./restore.sh"
    exit 1
fi

# Check if Makefile exists
if [ ! -f "$DWM_DIR/Makefile" ]; then
    echo -e "${RED}✗${NC} Makefile not found in $DWM_DIR"
    exit 1
fi

echo -e "${YELLOW}Building DWM...${NC}"
cd "$DWM_DIR"

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
sudo make clean 2>/dev/null || true

# Build and install
echo -e "${YELLOW}Building and installing DWM...${NC}"
if sudo make clean install; then
    echo ""
    echo -e "${GREEN}✓${NC} DWM built and installed successfully!"
else
    echo ""
    echo -e "${RED}✗${NC} DWM build failed"
    exit 1
fi

cd - > /dev/null

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   DWM Build Complete!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} Log out and log back in to apply changes"

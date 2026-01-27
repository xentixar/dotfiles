#!/bin/bash

# DMenu Build Script
# Rebuilds dmenu

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   DMenu Build Script                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

DMENU_DIR="$HOME/.config/dmenu"

# Check if dmenu directory exists
if [ ! -d "$DMENU_DIR" ]; then
    echo -e "${RED}✗${NC} DMenu directory not found at $DMENU_DIR"
    echo "Please restore dotfiles first: ./restore.sh"
    exit 1
fi

# Check if Makefile exists
if [ ! -f "$DMENU_DIR/Makefile" ]; then
    echo -e "${RED}✗${NC} Makefile not found in $DMENU_DIR"
    exit 1
fi

echo -e "${YELLOW}Building DMenu...${NC}"
cd "$DMENU_DIR"

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
sudo make clean 2>/dev/null || true

# Build and install
echo -e "${YELLOW}Building and installing DMenu...${NC}"
if sudo make clean install; then
    echo ""
    echo -e "${GREEN}✓${NC} DMenu built and installed successfully!"
else
    echo ""
    echo -e "${RED}✗${NC} DMenu build failed"
    exit 1
fi

cd - > /dev/null

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   DMenu Build Complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

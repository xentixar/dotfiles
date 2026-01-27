#!/bin/bash

# ST (Simple Terminal) Build Script
# Rebuilds st terminal

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ST Build Script                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

ST_DIR="$HOME/.config/st"

# Check if st directory exists
if [ ! -d "$ST_DIR" ]; then
    echo -e "${RED}✗${NC} ST directory not found at $ST_DIR"
    echo "Please restore dotfiles first: ./restore.sh"
    exit 1
fi

# Check if Makefile exists
if [ ! -f "$ST_DIR/Makefile" ]; then
    echo -e "${RED}✗${NC} Makefile not found in $ST_DIR"
    exit 1
fi

echo -e "${YELLOW}Building ST...${NC}"
cd "$ST_DIR"

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
sudo make clean 2>/dev/null || true

# Build and install
echo -e "${YELLOW}Building and installing ST...${NC}"
if sudo make clean install; then
    echo ""
    echo -e "${GREEN}✓${NC} ST built and installed successfully!"
else
    echo ""
    echo -e "${RED}✗${NC} ST build failed"
    exit 1
fi

cd - > /dev/null

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ST Build Complete!                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

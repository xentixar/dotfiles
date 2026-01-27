#!/bin/bash

# SLStatus Build Script
# Rebuilds slstatus (status bar)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   SLStatus Build Script               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

SLSTATUS_DIR="$HOME/.config/slstatus"

# Check if slstatus directory exists
if [ ! -d "$SLSTATUS_DIR" ]; then
    echo -e "${RED}✗${NC} SLStatus directory not found at $SLSTATUS_DIR"
    echo "Please restore dotfiles first: ./restore.sh"
    exit 1
fi

# Check if Makefile exists
if [ ! -f "$SLSTATUS_DIR/Makefile" ]; then
    echo -e "${RED}✗${NC} Makefile not found in $SLSTATUS_DIR"
    exit 1
fi

echo -e "${YELLOW}Building SLStatus...${NC}"
cd "$SLSTATUS_DIR"

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
sudo make clean 2>/dev/null || true

# Build and install
echo -e "${YELLOW}Building and installing SLStatus...${NC}"
if sudo make clean install; then
    echo ""
    echo -e "${GREEN}✓${NC} SLStatus built and installed successfully!"
else
    echo ""
    echo -e "${RED}✗${NC} SLStatus build failed"
    exit 1
fi

# Copy scripts to /usr/local/bin
echo ""
echo -e "${YELLOW}Installing SLStatus scripts...${NC}"
SCRIPT_DIR="$SLSTATUS_DIR/scripts"
if [ -d "$SCRIPT_DIR" ]; then
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            echo -n "  Installing $script_name... "
            sudo cp -f "$script" "/usr/local/bin/$script_name"
            sudo chmod +x "/usr/local/bin/$script_name"
            echo -e "${GREEN}✓${NC}"
        fi
    done
fi

# Copy get_apps.sh if it exists
if [ -f "$SLSTATUS_DIR/get_apps.sh" ]; then
    echo -n "  Installing get_apps.sh... "
    sudo cp -f "$SLSTATUS_DIR/get_apps.sh" "/usr/local/bin/get_apps.sh"
    sudo chmod +x "/usr/local/bin/get_apps.sh"
    echo -e "${GREEN}✓${NC}"
fi

cd - > /dev/null

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   SLStatus Build Complete!            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} Restart DWM or reload slstatus to apply changes"

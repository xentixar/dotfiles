#!/bin/bash

# Basic Development Packages Installation Script
# Installs basic development tools (nodejs, npm, python3)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Basic Development Packages           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Detect package manager
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt-get install -y"
    UPDATE_CMD="sudo apt-get update"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    UPDATE_CMD="sudo pacman -Sy"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    UPDATE_CMD="sudo dnf update"
else
    echo -e "${RED}Unsupported package manager${NC}"
    exit 1
fi

echo -e "${YELLOW}Detected package manager: $PKG_MANAGER${NC}"
echo ""

# Development packages - different names for different package managers
if [ "$PKG_MANAGER" = "apt" ]; then
    DEV_PACKAGES=(
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
    )
elif [ "$PKG_MANAGER" = "pacman" ]; then
    DEV_PACKAGES=(
        "nodejs"
        "npm"
        "python"
        "python-pip"
    )
elif [ "$PKG_MANAGER" = "dnf" ]; then
    DEV_PACKAGES=(
        "nodejs"
        "npm"
        "python3"
        "python3-pip"
    )
fi

# Update package list
echo -e "${YELLOW}Updating package list...${NC}"
$UPDATE_CMD &> /dev/null
echo -e "  ${GREEN}✓${NC} Package list updated"
echo ""

# Install packages
echo -e "${YELLOW}Installing development packages...${NC}"
for pkg in "${DEV_PACKAGES[@]}"; do
    echo -n "  Installing $pkg... "
    if $INSTALL_CMD "$pkg" &> /dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠${NC} (may already be installed or not available)"
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Development Packages Installed!    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

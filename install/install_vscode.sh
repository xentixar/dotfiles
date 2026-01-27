#!/bin/bash

# VSCode Installation Script
# Installs Visual Studio Code

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   VSCode Installation                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if VSCode is already installed
if command -v code &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} VSCode is already installed"
    code --version
    read -p "Reinstall VSCode? [y/N]: " reinstall
    if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

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

# Install VSCode based on package manager
if [ "$PKG_MANAGER" = "apt" ]; then
    echo -e "${YELLOW}Adding VSCode repository for Debian/Ubuntu...${NC}"
    
    # Install prerequisites
    $INSTALL_CMD wget gpg
    
    # Add Microsoft GPG key
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm /tmp/packages.microsoft.gpg
    
    $UPDATE_CMD
    echo -e "${YELLOW}Installing VSCode...${NC}"
    $INSTALL_CMD code
    
elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo -e "${YELLOW}Installing VSCode from AUR...${NC}"
    # Check if yay is available
    if command -v yay &> /dev/null; then
        yay -S --noconfirm visual-studio-code-bin
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm visual-studio-code-bin
    else
        echo -e "${YELLOW}Installing VSCode from official repos...${NC}"
        $INSTALL_CMD code
    fi
    
elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo -e "${YELLOW}Adding VSCode repository for Fedora/RHEL...${NC}"
    
    # Add Microsoft repository
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    
    $UPDATE_CMD
    echo -e "${YELLOW}Installing VSCode...${NC}"
    $INSTALL_CMD code
fi

# Verify installation
if command -v code &> /dev/null; then
    echo ""
    echo -e "${GREEN}✓${NC} VSCode installation completed successfully!"
    echo ""
    echo -e "${BLUE}VSCode Version:${NC}"
    code --version
else
    echo -e "${RED}✗${NC} VSCode installation failed"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   VSCode Installation Complete!      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

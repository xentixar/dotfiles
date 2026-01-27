#!/bin/bash

# Google Chrome Installation Script
# Installs Google Chrome Stable

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Google Chrome Installation      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if Chrome is already installed
CHROME_CMD=""
if command -v google-chrome &> /dev/null; then
    CHROME_CMD="google-chrome"
elif command -v google-chrome-stable &> /dev/null; then
    CHROME_CMD="google-chrome-stable"
fi

if [ -n "$CHROME_CMD" ]; then
    echo -e "${YELLOW}⚠${NC} Google Chrome is already installed"
    "$CHROME_CMD" --version || true
    read -p "Reinstall Google Chrome? [y/N]: " reinstall
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

# Install Google Chrome based on package manager
if [ "$PKG_MANAGER" = "apt" ]; then
    echo -e "${YELLOW}Setting up Google Chrome repository for Debian/Ubuntu...${NC}"

    # Install prerequisites
    $INSTALL_CMD wget gpg 2>/dev/null

    # Clean up existing Chrome repository entries and keys to avoid conflicts
    echo -e "${YELLOW}⚠${NC} Cleaning up existing Chrome repository entries..."
    sudo rm -f /etc/apt/sources.list.d/google-chrome.list
    sudo rm -f /etc/apt/sources.list.d/google-chrome*.list
    sudo rm -f /etc/apt/sources.list.d/google-chrome.sources
    sudo rm -f /etc/apt/sources.list.d/google-chrome*.sources

    if grep -q "dl.google.com/linux/chrome/deb" /etc/apt/sources.list 2>/dev/null; then
        sudo sed -i '/dl.google.com\/linux\/chrome\/deb/d' /etc/apt/sources.list
    fi

    # Remove old Google keys
    echo -e "${YELLOW}⚠${NC} Removing existing Google Chrome GPG keys..."
    sudo rm -f /etc/apt/trusted.gpg.d/google*.gpg
    sudo rm -f /usr/share/keyrings/google-chrome.gpg

    # Clean apt cache
    sudo apt-get clean 2>/dev/null || true

    # Add Google Chrome GPG key (modern keyring location)
    echo -e "${YELLOW}Adding Google Chrome GPG key...${NC}"
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg > /dev/null

    # Add Chrome repository with Signed-By
    echo -e "${YELLOW}Adding Google Chrome repository...${NC}"
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

    # Update package lists
    echo -e "${YELLOW}Updating package lists...${NC}"
    $UPDATE_CMD

    echo -e "${YELLOW}Installing Google Chrome...${NC}"
    $INSTALL_CMD google-chrome-stable

elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo -e "${YELLOW}Installing Google Chrome from AUR...${NC}"
    # Check if yay or paru is available
    if command -v yay &> /dev/null; then
        yay -S --noconfirm google-chrome
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm google-chrome
    else
        echo -e "${RED}No AUR helper (yay/paru) found.${NC}"
        echo -e "${YELLOW}Please install yay or paru first, then re-run this script.${NC}"
        exit 1
    fi

elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo -e "${YELLOW}Adding Google Chrome repository for Fedora/RHEL...${NC}"

    # Import Google Linux signing key
    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub

    # Create repo file
    sudo sh -c 'cat > /etc/yum.repos.d/google-chrome.repo << "EOF"
[google-chrome]
name=Google Chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF'

    $UPDATE_CMD
    echo -e "${YELLOW}Installing Google Chrome...${NC}"
    $INSTALL_CMD google-chrome-stable
fi

# Verify installation
CHROME_CMD=""
if command -v google-chrome &> /dev/null; then
    CHROME_CMD="google-chrome"
elif command -v google-chrome-stable &> /dev/null; then
    CHROME_CMD="google-chrome-stable"
fi

if [ -n "$CHROME_CMD" ]; then
    echo ""
    echo -e "${GREEN}✓${NC} Google Chrome installation completed successfully!"
    echo ""
    echo -e "${BLUE}Google Chrome Version:${NC}"
    "$CHROME_CMD" --version || true
else
    echo -e "${RED}✗${NC} Google Chrome installation failed"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Google Chrome Installation Complete! ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"


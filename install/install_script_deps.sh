#!/bin/bash

# Script Dependencies Installation Script
# Installs utilities required by dotfiles scripts (nvim, xclip, scrot, wmctrl, etc.)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Script Dependencies Installation     ║${NC}"
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

# Script dependencies - different names for different package managers
if [ "$PKG_MANAGER" = "apt" ]; then
    SCRIPT_PACKAGES=(
        "xclip"
        "scrot"
        "wmctrl"
        "alsa-utils"
        "bluez"
        "xinput"
    )
elif [ "$PKG_MANAGER" = "pacman" ]; then
    SCRIPT_PACKAGES=(
        "xclip"
        "scrot"
        "wmctrl"
        "alsa-utils"
        "bluez"
        "xorg-xinput"
    )
elif [ "$PKG_MANAGER" = "dnf" ]; then
    SCRIPT_PACKAGES=(
        "xclip"
        "scrot"
        "wmctrl"
        "alsa-utils"
        "bluez"
        "xorg-xinput"
    )
fi

# Update package list
echo -e "${YELLOW}Updating package list...${NC}"
$UPDATE_CMD &> /dev/null
echo -e "  ${GREEN}✓${NC} Package list updated"
echo ""

# Install packages
echo -e "${YELLOW}Installing script dependencies...${NC}"
for pkg in "${SCRIPT_PACKAGES[@]}"; do
    echo -n "  Installing $pkg... "
    if $INSTALL_CMD "$pkg" &> /dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠${NC} (may already be installed or not available)"
    fi
done

# Install latest Neovim (prebuilt tarball) to /opt/nvim and symlink to /usr/local/bin
echo ""
echo -e "${YELLOW}Installing latest Neovim...${NC}"
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
TMP_DIR="$(mktemp -d)"
if command -v curl &> /dev/null; then
    DOWNLOADER="curl -L"
else
    DOWNLOADER="wget -O-"
fi
echo -e "  Downloading Neovim from ${NVIM_URL}..."
if $DOWNLOADER "$NVIM_URL" | tar xz -C "$TMP_DIR"; then
    echo -e "  ${GREEN}✓${NC} Downloaded and extracted Neovim"
    sudo rm -rf /opt/nvim
    sudo mkdir -p /opt
    sudo mv "$TMP_DIR/nvim-linux64" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    echo -e "  ${GREEN}✓${NC} Installed Neovim to /opt/nvim and linked /usr/local/bin/nvim"
else
    echo -e "  ${YELLOW}⚠${NC} Failed to download or extract Neovim; keeping any existing nvim installation."
fi
rm -rf "$TMP_DIR"

# Check for NVIDIA GPU tools (optional)
echo ""
echo -e "${YELLOW}Checking for NVIDIA GPU tools...${NC}"
if command -v nvidia-smi &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} nvidia-smi already available"
else
    echo -e "  ${YELLOW}⚠${NC} nvidia-smi not found (install nvidia-utils if you have NVIDIA GPU)"
    if [ "$PKG_MANAGER" = "apt" ]; then
        echo -e "  ${YELLOW}  Run: sudo apt-get install nvidia-utils${NC}"
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        echo -e "  ${YELLOW}  Run: sudo pacman -S nvidia-utils${NC}"
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        echo -e "  ${YELLOW}  Run: sudo dnf install nvidia-utils${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Script Dependencies Installed!       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

# Install user scripts to /usr/local/bin
echo ""
echo -e "${YELLOW}Installing user scripts to /usr/local/bin...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../scripts"
if [ -d "$SCRIPT_DIR" ]; then
    INSTALLED=0
    for script in "$SCRIPT_DIR"/*.sh; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            # Skip install_scripts.sh itself
            if [ "$script_name" != "install_scripts.sh" ]; then
                base_name="${script_name%.sh}"
                echo -n "  Installing $script_name and $base_name... "
                sudo cp -f "$script" "/usr/local/bin/$script_name"
                sudo chmod +x "/usr/local/bin/$script_name"
                # Also install without extension for convenience
                sudo cp -f "$script" "/usr/local/bin/$base_name"
                sudo chmod +x "/usr/local/bin/$base_name"
                echo -e "${GREEN}✓${NC}"
                INSTALLED=$((INSTALLED + 1))
            fi
        fi
    done
    
    if [ $INSTALLED -gt 0 ]; then
        echo ""
        echo -e "${GREEN}✓${NC} Installed $INSTALLED script(s) to /usr/local/bin"
    fi
else
    echo -e "${YELLOW}⚠${NC} Scripts directory not found"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Script Setup Complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

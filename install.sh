#!/bin/bash

# System setup script
# Installs dependencies and sets up the system

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   System Setup Script                 ║${NC}"
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

# Essential packages
ESSENTIAL_PACKAGES=(
    "git"
    "curl"
    "wget"
    "zsh"
    "vim"
    "tmux"
    "build-essential"
    "make"
    "gcc"
)

# Development tools
DEV_PACKAGES=(
    "nodejs"
    "npm"
    "python3"
    "python3-pip"
)

# Suckless tools dependencies
SUCKLESS_PACKAGES=(
    "libx11-dev"
    "libxft-dev"
    "libxinerama-dev"
    "libxrandr-dev"
    "libfreetype6-dev"
    "libfontconfig1-dev"
)

# Function to install packages
install_packages() {
    local category=$1
    shift
    local packages=("$@")
    
    echo -e "${YELLOW}Installing $category packages...${NC}"
    for pkg in "${packages[@]}"; do
        if [ "$PKG_MANAGER" = "apt" ]; then
            # Handle different package names for apt
            case $pkg in
                "build-essential")
                    pkg_name="build-essential"
                    ;;
                "libx11-dev")
                    pkg_name="libx11-dev"
                    ;;
                *)
                    pkg_name="$pkg"
                    ;;
            esac
        else
            pkg_name="$pkg"
        fi
        
        echo -n "  Installing $pkg_name... "
        if $INSTALL_CMD "$pkg_name" &> /dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗${NC} (may already be installed or not available)"
        fi
    done
}

# Update package list
echo -e "${YELLOW}Updating package list...${NC}"
$UPDATE_CMD &> /dev/null
echo -e "  ${GREEN}✓${NC} Package list updated"
echo ""

# Install essential packages
install_packages "Essential" "${ESSENTIAL_PACKAGES[@]}"
echo ""

# Ask about development tools
read -p "Install development tools (nodejs, npm, python3)? [y/N]: " install_dev
if [[ "$install_dev" =~ ^[Yy]$ ]]; then
    install_packages "Development" "${DEV_PACKAGES[@]}"
    echo ""
fi

# Ask about suckless tools dependencies
read -p "Install dependencies for suckless tools (dwm, st, dmenu, slstatus)? [y/N]: " install_suckless
if [[ "$install_suckless" =~ ^[Yy]$ ]]; then
    install_packages "Suckless Tools" "${SUCKLESS_PACKAGES[@]}"
    echo ""
fi

# Set zsh as default shell
read -p "Set zsh as default shell? [y/N]: " set_zsh
if [[ "$set_zsh" =~ ^[Yy]$ ]]; then
    if command -v zsh &> /dev/null; then
        chsh -s $(which zsh)
        echo -e "  ${GREEN}✓${NC} Zsh set as default shell (restart terminal to apply)"
    else
        echo -e "  ${RED}✗${NC} Zsh not installed"
    fi
fi

# Ask about development tools installation
echo ""
echo -e "${YELLOW}Development Tools Installation${NC}"
read -p "Install development tools (PHP 8.4, Composer, Node.js via NVM, VSCode)? [y/N]: " install_dev_tools
if [[ "$install_dev_tools" =~ ^[Yy]$ ]]; then
    INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install"
    if [ -d "$INSTALL_DIR" ]; then
        echo ""
        echo -e "${YELLOW}Choose installation method:${NC}"
        echo "  1) Install all development tools"
        echo "  2) Choose individual tools"
        read -p "Enter choice [1-2] (default: 1): " install_choice
        install_choice=${install_choice:-1}
        
        if [ "$install_choice" = "1" ]; then
            if [ -f "$INSTALL_DIR/install_all.sh" ]; then
                bash "$INSTALL_DIR/install_all.sh"
            else
                echo -e "${RED}✗${NC} install_all.sh not found"
            fi
        else
            echo ""
            echo -e "${YELLOW}Available tools:${NC}"
            echo "  1) PHP 8.4"
            echo "  2) Composer"
            echo "  3) Node.js via NVM"
            echo "  4) VSCode"
            read -p "Enter tool numbers (comma-separated, e.g., 1,2,3): " tool_numbers
            
            IFS=',' read -ra TOOLS <<< "$tool_numbers"
            for tool_num in "${TOOLS[@]}"; do
                case $tool_num in
                    1)
                        [ -f "$INSTALL_DIR/install_php84.sh" ] && bash "$INSTALL_DIR/install_php84.sh"
                        ;;
                    2)
                        [ -f "$INSTALL_DIR/install_composer.sh" ] && bash "$INSTALL_DIR/install_composer.sh"
                        ;;
                    3)
                        [ -f "$INSTALL_DIR/install_nodejs_nvm.sh" ] && bash "$INSTALL_DIR/install_nodejs_nvm.sh"
                        ;;
                    4)
                        [ -f "$INSTALL_DIR/install_vscode.sh" ] && bash "$INSTALL_DIR/install_vscode.sh"
                        ;;
                esac
            done
        fi
    else
        echo -e "${YELLOW}⚠${NC} install/ directory not found"
    fi
    echo ""
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Setup Completed!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Run ./restore.sh to restore your dotfiles"
echo "  2. Rebuild suckless tools if needed:"
echo "     ./build/build_all.sh (or individual: ./build/build_dwm.sh, etc.)"
echo "  3. Install development tools:"
echo "     ./install/install_all.sh (or individual scripts)"

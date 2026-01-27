#!/bin/bash

# PHP 8.4 Installation Script
# Installs PHP 8.4 and common extensions

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   PHP 8.4 Installation                ║${NC}"
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

# Check if PHP 8.4 is already installed
if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
    if [ "$PHP_VERSION" = "8.4" ]; then
        echo -e "${GREEN}✓${NC} PHP 8.4 is already installed"
        php -v
        exit 0
    else
        echo -e "${YELLOW}⚠${NC} PHP $PHP_VERSION is installed, but PHP 8.4 is required"
        read -p "Continue with installation? [y/N]: " continue_install
        if [[ ! "$continue_install" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
fi

# Install PHP 8.4 based on package manager
if [ "$PKG_MANAGER" = "apt" ]; then
    echo -e "${YELLOW}Adding PHP 8.4 repository for Debian/Ubuntu...${NC}"
    
    # Add PHP repository
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:ondrej/php
    $UPDATE_CMD
    
    echo -e "${YELLOW}Installing PHP 8.4 and common extensions...${NC}"
    $INSTALL_CMD php8.4 php8.4-cli php8.4-fpm php8.4-common php8.4-mysql php8.4-zip php8.4-gd php8.4-mbstring php8.4-curl php8.4-xml php8.4-bcmath php8.4-intl php8.4-readline
    
elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo -e "${YELLOW}Installing PHP 8.4 and common extensions...${NC}"
    # Arch Linux typically has latest PHP in repos
    $INSTALL_CMD php php-fpm php-gd php-intl php-sqlite php-pgsql
    
elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo -e "${YELLOW}Installing PHP 8.4 and common extensions...${NC}"
    # Fedora/RHEL
    $INSTALL_CMD php php-cli php-fpm php-common php-mysqlnd php-zip php-gd php-mbstring php-curl php-xml php-bcmath php-intl php-readline
fi

# Verify installation
if command -v php &> /dev/null; then
    echo ""
    echo -e "${GREEN}✓${NC} PHP installation completed successfully!"
    echo ""
    echo -e "${BLUE}PHP Version:${NC}"
    php -v
    echo ""
    echo -e "${BLUE}Installed extensions:${NC}"
    php -m
else
    echo -e "${RED}✗${NC} PHP installation failed"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   PHP 8.4 Installation Complete!      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

#!/bin/bash

# Composer Installation Script
# Installs Composer globally

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Composer Installation               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo -e "${RED}✗${NC} PHP is not installed. Please install PHP first."
    echo "Run: ./install/install_php84.sh"
    exit 1
fi

# Check if Composer is already installed
if command -v composer &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} Composer is already installed"
    composer --version
    read -p "Reinstall Composer? [y/N]: " reinstall
    if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
        exit 0
    fi
    # Remove existing Composer
    if [ -f /usr/local/bin/composer ]; then
        sudo rm /usr/local/bin/composer
    fi
    if [ -f "$HOME/.local/bin/composer" ]; then
        rm "$HOME/.local/bin/composer"
    fi
fi

# Download and install Composer
echo -e "${YELLOW}Downloading Composer installer...${NC}"
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    echo -e "${RED}✗${NC} Composer installer checksum verification failed!"
    rm composer-setup.php
    exit 1
fi

echo -e "${GREEN}✓${NC} Checksum verified"

echo -e "${YELLOW}Installing Composer...${NC}"
php composer-setup.php --install-dir=/tmp --filename=composer
rm composer-setup.php

# Move to global location
echo -e "${YELLOW}Moving Composer to /usr/local/bin...${NC}"
sudo mv /tmp/composer /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Verify installation
if command -v composer &> /dev/null; then
    echo ""
    echo -e "${GREEN}✓${NC} Composer installation completed successfully!"
    echo ""
    echo -e "${BLUE}Composer Version:${NC}"
    composer --version
    echo ""
    echo -e "${BLUE}Composer global directory:${NC}"
    composer global config home 2>/dev/null || echo "Run 'composer global config home' to set global directory"
else
    echo -e "${RED}✗${NC} Composer installation failed"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Composer Installation Complete!    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

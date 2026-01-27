#!/bin/bash

# PHP Installation Script
# Installs PHP and common extensions (version from versions.json; supports specific versions or 'latest')

# Load version helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/version_utils.sh" ]; then
    # shellcheck disable=SC1090
    . "$SCRIPT_DIR/version_utils.sh"
fi

# Fallback get_version if version_utils.sh is unavailable
if ! declare -f get_version >/dev/null 2>&1; then
    get_version() {
        # $1 = tool, $2 = default
        echo "$2"
    }
fi

PHP_TARGET_VERSION="$(get_version php "8.4")"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   PHP $PHP_TARGET_VERSION Installation                 ║${NC}"
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

# Check if PHP is already installed
if command -v php &> /dev/null; then
    INSTALLED_PHP_VERSION="$(php -v | head -n 1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)"

    if [ "$PHP_TARGET_VERSION" = "latest" ]; then
        echo -e "${GREEN}✓${NC} PHP $INSTALLED_PHP_VERSION is already installed (target: latest)"
        php -v
        exit 0
    elif [ "$INSTALLED_PHP_VERSION" = "$PHP_TARGET_VERSION" ]; then
        echo -e "${GREEN}✓${NC} PHP $INSTALLED_PHP_VERSION is already installed"
        php -v
        exit 0
    else
        echo -e "${YELLOW}⚠${NC} PHP $INSTALLED_PHP_VERSION is installed, but PHP $PHP_TARGET_VERSION is configured"
        read -p "Continue with installation? [y/N]: " continue_install
        if [[ ! "$continue_install" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
fi

# Install PHP based on package manager
if [ "$PKG_MANAGER" = "apt" ]; then
    if [ "$PHP_TARGET_VERSION" = "latest" ]; then
        echo -e "${YELLOW}Installing latest PHP from Debian/Ubuntu repositories...${NC}"
        $UPDATE_CMD
        $INSTALL_CMD php php-cli php-fpm php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-bcmath php-intl php-readline
    else
        echo -e "${YELLOW}Adding PHP $PHP_TARGET_VERSION repository for Debian/Ubuntu...${NC}"
        
        # Add PHP repository
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:ondrej/php
        $UPDATE_CMD
        
        echo -e "${YELLOW}Installing PHP $PHP_TARGET_VERSION and common extensions...${NC}"
        $INSTALL_CMD php$PHP_TARGET_VERSION php$PHP_TARGET_VERSION-cli php$PHP_TARGET_VERSION-fpm php$PHP_TARGET_VERSION-common php$PHP_TARGET_VERSION-mysql php$PHP_TARGET_VERSION-zip php$PHP_TARGET_VERSION-gd php$PHP_TARGET_VERSION-mbstring php$PHP_TARGET_VERSION-curl php$PHP_TARGET_VERSION-xml php$PHP_TARGET_VERSION-bcmath php$PHP_TARGET_VERSION-intl php$PHP_TARGET_VERSION-readline
    fi
    
elif [ "$PKG_MANAGER" = "pacman" ]; then
    echo -e "${YELLOW}Installing PHP (latest in Arch repos) and common extensions...${NC}"
    # Arch Linux typically has latest PHP in repos
    $INSTALL_CMD php php-fpm php-gd php-intl php-sqlite php-pgsql
    
elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo -e "${YELLOW}Installing PHP (latest in Fedora/RHEL repos) and common extensions...${NC}"
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
echo -e "${GREEN}║   PHP $PHP_TARGET_VERSION Installation Complete!     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

# Install Composer after PHP
echo ""
echo -e "${YELLOW}Installing Composer...${NC}"

# Check if Composer is already installed
if command -v composer &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} Composer is already installed"
    composer --version
else
    # Download and install Composer
    echo -e "${YELLOW}Downloading Composer installer...${NC}"
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        echo -e "${RED}✗${NC} Composer installer checksum verification failed!"
        rm -f composer-setup.php
    else
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
        else
            echo -e "${YELLOW}⚠${NC} Composer installation completed but may not be in PATH"
        fi
    fi
fi

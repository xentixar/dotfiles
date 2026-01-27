#!/bin/bash

# Node.js Installation via NVM Script
# Installs NVM and Node.js version from versions.json (supports: specific versions, 'lts', 'latest')

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

NODE_VERSION="$(get_version nodejs "lts")"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Node.js via NVM Installation         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if NVM is already installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo -e "${YELLOW}⚠${NC} NVM appears to be already installed"
    source "$HOME/.nvm/nvm.sh"
    if command -v nvm &> /dev/null || command -v nvm.sh &> /dev/null; then
        echo -e "${GREEN}✓${NC} NVM is installed"
        nvm --version
        read -p "Reinstall NVM? [y/N]: " reinstall
        if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
            # Just install/update Node.js
            echo -e "${YELLOW}Installing Node.js ($NODE_VERSION)...${NC}"
            if [ "$NODE_VERSION" = "latest" ]; then
                nvm install node
                nvm use node
                nvm alias default node
            elif [ "$NODE_VERSION" = "lts" ]; then
                nvm install --lts
                nvm use --lts
                nvm alias default lts/*
            else
                nvm install "$NODE_VERSION"
                nvm use "$NODE_VERSION"
                nvm alias default "$NODE_VERSION"
            fi
            echo ""
            echo -e "${GREEN}✓${NC} Node.js installation completed!"
            node --version
            npm --version
            exit 0
        fi
    fi
fi

# Install NVM
echo -e "${YELLOW}Installing NVM...${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Source NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Verify NVM installation
if ! command -v nvm &> /dev/null; then
    # Try to source it again
    source "$HOME/.nvm/nvm.sh" 2>/dev/null || {
        echo -e "${RED}✗${NC} NVM installation failed. Please restart your terminal and try again."
        echo "Or run: source ~/.nvm/nvm.sh"
        exit 1
    }
fi

echo -e "${GREEN}✓${NC} NVM installed successfully"
nvm --version

# Install configured Node.js version
echo ""
echo -e "${YELLOW}Installing Node.js ($NODE_VERSION)...${NC}"
if [ "$NODE_VERSION" = "latest" ]; then
    nvm install node
    nvm use node
    nvm alias default node
elif [ "$NODE_VERSION" = "lts" ]; then
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
else
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
fi

# Verify installation
if command -v node &> /dev/null; then
    echo ""
    echo -e "${GREEN}✓${NC} Node.js installation completed successfully!"
    echo ""
    echo -e "${BLUE}Node.js Version:${NC}"
    node --version
    echo ""
    echo -e "${BLUE}npm Version:${NC}"
    npm --version
    echo ""
    echo -e "${YELLOW}Note:${NC} Add the following to your ~/.zshrc or ~/.bashrc if not already present:"
    echo ""
    echo 'export NVM_DIR="$HOME/.nvm"'
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
else
    echo -e "${RED}✗${NC} Node.js installation failed"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Node.js Installation Complete!       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

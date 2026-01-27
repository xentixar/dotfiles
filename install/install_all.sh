#!/bin/bash

# Install All Script
# Installs all development tools (PHP 8.4, Composer, Node.js via NVM, VSCode)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Install All Development Tools        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS=("php" "composer" "nodejs_nvm" "vscode" "chrome")

for tool in "${TOOLS[@]}"; do
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Installing $tool...${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if bash "$INSTALL_DIR/install_${tool}.sh"; then
        echo -e "${GREEN}✓${NC} $tool completed"
    else
        echo -e "${RED}✗${NC} $tool failed"
        read -p "Continue with remaining installations? [Y/n]: " continue_install
        if [[ "$continue_install" =~ ^[Nn]$ ]]; then
            exit 1
        fi
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   All Installations Complete!          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

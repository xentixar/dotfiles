#!/bin/bash

# System setup script
# Installs dependencies and sets up the system

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"

# Function to extract title from script file (first comment line after shebang)
get_script_title() {
    local script_file="$1"
    # Read first comment line (skip shebang and empty lines, get first # comment)
    local title=$(grep -E "^# " "$script_file" 2>/dev/null | head -1 | sed 's/^# //')
    if [ -z "$title" ]; then
        # Fallback: use filename without extension
        basename "$script_file" .sh
    else
        echo "$title"
    fi
}

# Discover installation scripts
declare -a SCRIPT_FILES
declare -a SCRIPT_NAMES
declare -A SELECTIONS

if [ -d "$INSTALL_DIR" ]; then
    # Find all install_*.sh files except install_all.sh
    while IFS= read -r -d '' script; do
        basename=$(basename "$script")
        if [[ "$basename" != "install_all.sh" ]]; then
            SCRIPT_FILES+=("$script")
            SCRIPT_NAMES+=("$(get_script_title "$script")")
            # Initialize selection to 0 (not selected)
            SELECTIONS[${#SCRIPT_FILES[@]}]=0
        fi
    done < <(find "$INSTALL_DIR" -maxdepth 1 -name "install_*.sh" -type f -print0 | sort -z)
fi

# Add special option: Set zsh as default shell
SPECIAL_OPTION_INDEX=$((${#SCRIPT_FILES[@]} + 1))
SELECTIONS[$SPECIAL_OPTION_INDEX]=0

# Function to display menu
show_menu() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Installation Selection Menu          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Select what to install (toggle with number, press Enter to proceed):${NC}"
    echo ""
    
    # Display script options
    for i in "${!SCRIPT_FILES[@]}"; do
        local index=$((i + 1))
        if [ "${SELECTIONS[$index]}" -eq 1 ]; then
            echo -e "  ${GREEN}[✓]${NC} $index. ${SCRIPT_NAMES[$i]}"
        else
            echo -e "  ${YELLOW}[ ]${NC} $index. ${SCRIPT_NAMES[$i]}"
        fi
    done
    
    # Display special option
    if [ "${SELECTIONS[$SPECIAL_OPTION_INDEX]}" -eq 1 ]; then
        echo -e "  ${GREEN}[✓]${NC} $SPECIAL_OPTION_INDEX. Set zsh as default shell"
    else
        echo -e "  ${YELLOW}[ ]${NC} $SPECIAL_OPTION_INDEX. Set zsh as default shell"
    fi
    
    echo ""
    echo -e "${CYAN}Press Enter to start installation, or type numbers (1-$SPECIAL_OPTION_INDEX) to toggle (e.g., 1 or 1,2,3)${NC}"
}

# Initial menu display
show_menu

# Interactive selection loop
while true; do
    read -p "> " input
    
    # If Enter is pressed, break the loop
    if [ -z "$input" ]; then
        break
    fi
    
    # Check if input contains comma (multiple selections)
    if [[ "$input" == *","* ]]; then
        # Handle comma-separated input
        IFS=',' read -ra NUMBERS <<< "$input"
        INVALID=false
        for num in "${NUMBERS[@]}"; do
            # Trim whitespace
            num=$(echo "$num" | xargs)
            if [[ "$num" =~ ^[0-9]+$ ]]; then
                if [ "$num" -ge 1 ] && [ "$num" -le "$SPECIAL_OPTION_INDEX" ]; then
                    # Toggle selection
                    if [ "${SELECTIONS[$num]}" -eq 1 ]; then
                        SELECTIONS[$num]=0
                    else
                        SELECTIONS[$num]=1
                    fi
                else
                    INVALID=true
                fi
            else
                INVALID=true
            fi
        done
        if [ "$INVALID" = true ]; then
            echo -e "${RED}Invalid input. Please enter numbers between 1-$SPECIAL_OPTION_INDEX (e.g., 1 or 1,2,3) or press Enter to proceed.${NC}"
            sleep 1
        fi
        show_menu
    elif [[ "$input" =~ ^[0-9]+$ ]]; then
        # Single number input
        if [ "$input" -ge 1 ] && [ "$input" -le "$SPECIAL_OPTION_INDEX" ]; then
            # Toggle selection
            if [ "${SELECTIONS[$input]}" -eq 1 ]; then
                SELECTIONS[$input]=0
            else
                SELECTIONS[$input]=1
            fi
            show_menu
        else
            echo -e "${RED}Invalid input. Please enter a number between 1-$SPECIAL_OPTION_INDEX or press Enter to proceed.${NC}"
            sleep 1
            show_menu
        fi
    else
        echo -e "${RED}Invalid input. Please enter numbers between 1-$SPECIAL_OPTION_INDEX (e.g., 1 or 1,2,3) or press Enter to proceed.${NC}"
        sleep 1
        show_menu
    fi
done

# Check if anything is selected
TOTAL_SELECTED=0
for i in $(seq 1 $SPECIAL_OPTION_INDEX); do
    if [ "${SELECTIONS[$i]}" -eq 1 ]; then
        TOTAL_SELECTED=$((TOTAL_SELECTED + 1))
    fi
done

if [ "$TOTAL_SELECTED" -eq 0 ]; then
    echo -e "${YELLOW}No items selected. Exiting.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Starting installation...${NC}"
echo ""

# Install selected items
for i in "${!SCRIPT_FILES[@]}"; do
    index=$((i + 1))
    if [ "${SELECTIONS[$index]}" -eq 1 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        bash "${SCRIPT_FILES[$i]}"
        echo ""
    fi
done

# Handle special option: Set zsh as default shell
if [ "${SELECTIONS[$SPECIAL_OPTION_INDEX]}" -eq 1 ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Setting zsh as default shell...${NC}"
    if command -v zsh &> /dev/null; then
        chsh -s $(which zsh)
        echo -e "  ${GREEN}✓${NC} Zsh set as default shell (restart terminal to apply)"
    else
        echo -e "  ${RED}✗${NC} Zsh not installed. Please install essential packages first."
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

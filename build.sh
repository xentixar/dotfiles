#!/bin/bash

# Build script
# Rebuilds tools using scripts from the build/ folder

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Build Tools Script                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"

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

# Discover build scripts
declare -a SCRIPT_FILES
declare -a SCRIPT_NAMES
declare -A SELECTIONS

if [ -d "$BUILD_DIR" ]; then
    # Find all build_*.sh files except build_all.sh
    while IFS= read -r -d '' script; do
        basename=$(basename "$script")
        if [[ "$basename" != "build_all.sh" ]]; then
            SCRIPT_FILES+=("$script")
            SCRIPT_NAMES+=("$(get_script_title "$script")")
            # Initialize selection to 0 (not selected)
            SELECTIONS[${#SCRIPT_FILES[@]}]=0
        fi
    done < <(find "$BUILD_DIR" -maxdepth 1 -name "build_*.sh" -type f -print0 | sort -z)
fi

# Check if any scripts were found
if [ ${#SCRIPT_FILES[@]} -eq 0 ]; then
    echo -e "${YELLOW}No build scripts found in $BUILD_DIR${NC}"
    exit 0
fi

# Function to display menu
show_menu() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Build Selection Menu                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Select what to build (toggle with number, press Enter to proceed):${NC}"
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
    
    echo ""
    local max_option=${#SCRIPT_FILES[@]}
    echo -e "${CYAN}Press Enter to start building, or type a number (1-$max_option) to toggle${NC}"
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
    
    # Validate input is a number
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        local max_option=${#SCRIPT_FILES[@]}
        if [ "$input" -ge 1 ] && [ "$input" -le "$max_option" ]; then
            # Toggle selection
            if [ "${SELECTIONS[$input]}" -eq 1 ]; then
                SELECTIONS[$input]=0
            else
                SELECTIONS[$input]=1
            fi
            show_menu
        else
            echo -e "${RED}Invalid input. Please enter a number between 1-$max_option or press Enter to proceed.${NC}"
            sleep 1
            show_menu
        fi
    else
        local max_option=${#SCRIPT_FILES[@]}
        echo -e "${RED}Invalid input. Please enter a number between 1-$max_option or press Enter to proceed.${NC}"
        sleep 1
        show_menu
    fi
done

# Check if anything is selected
TOTAL_SELECTED=0
local max_option=${#SCRIPT_FILES[@]}
for i in $(seq 1 $max_option); do
    if [ "${SELECTIONS[$i]}" -eq 1 ]; then
        TOTAL_SELECTED=$((TOTAL_SELECTED + 1))
    fi
done

if [ "$TOTAL_SELECTED" -eq 0 ]; then
    echo -e "${YELLOW}No items selected. Exiting.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Starting build...${NC}"
echo ""

# Build selected items
for i in "${!SCRIPT_FILES[@]}"; do
    local index=$((i + 1))
    if [ "${SELECTIONS[$index]}" -eq 1 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        bash "${SCRIPT_FILES[$i]}"
        echo ""
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Build Completed!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

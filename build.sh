#!/bin/bash

# Build script
# Rebuilds tools using scripts from the build/ folder

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
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

# Current cursor position (1-based)
CURRENT_POS=1
TOTAL_OPTIONS=${#SCRIPT_FILES[@]}

# Save terminal settings
stty_save=$(stty -g)

# Function to restore terminal
restore_terminal() {
    stty "$stty_save" 2>/dev/null
    echo -e "\033[?25h" # Show cursor
    echo "" # New line
}

# Function to handle exit
cleanup_and_exit() {
    restore_terminal
    exit 0
}

# Trap to restore terminal on exit
trap cleanup_and_exit EXIT INT TERM

# Function to display menu
show_menu() {
    # Clear screen and move cursor to top
    clear
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Build Selection Menu                 ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Use ↑↓ to navigate, SPACE to toggle, ENTER to proceed${NC}"
    echo ""
    
    # Display script options
    for i in "${!SCRIPT_FILES[@]}"; do
        index=$((i + 1))
        if [ $index -eq $CURRENT_POS ]; then
            # Highlighted (current position)
            if [ "${SELECTIONS[$index]}" -eq 1 ]; then
                echo -e "  ${BOLD}${GREEN}[✓]${NC} ${BOLD}${CYAN}>${NC} ${SCRIPT_NAMES[$i]}"
            else
                echo -e "  ${BOLD}${YELLOW}[ ]${NC} ${BOLD}${CYAN}>${NC} ${SCRIPT_NAMES[$i]}"
            fi
        else
            # Not highlighted
            if [ "${SELECTIONS[$index]}" -eq 1 ]; then
                echo -e "  ${GREEN}[✓]${NC}   ${SCRIPT_NAMES[$i]}"
            else
                echo -e "  ${YELLOW}[ ]${NC}   ${SCRIPT_NAMES[$i]}"
            fi
        fi
    done
    
    echo ""
}

# Configure terminal for raw input
stty -echo
stty cbreak
echo -e "\033[?25l" # Hide cursor

# Initial menu display
show_menu

# Interactive selection loop
while true; do
    # Read single character
    char=$(dd bs=1 count=1 2>/dev/null)
    
    # Check for escape sequence (arrow keys)
    if [ "$char" = $'\033' ]; then
        # Read the rest of the escape sequence
        read -rsn1 -t 0.1 tmp
        if [ "$tmp" = "[" ]; then
            read -rsn1 -t 0.1 tmp
            case "$tmp" in
                A) # Up arrow
                    if [ $CURRENT_POS -gt 1 ]; then
                        CURRENT_POS=$((CURRENT_POS - 1))
                        show_menu
                    fi
                    ;;
                B) # Down arrow
                    if [ $CURRENT_POS -lt $TOTAL_OPTIONS ]; then
                        CURRENT_POS=$((CURRENT_POS + 1))
                        show_menu
                    fi
                    ;;
            esac
        fi
    elif [ "$char" = " " ]; then
        # Space to toggle selection
        if [ "${SELECTIONS[$CURRENT_POS]}" -eq 1 ]; then
            SELECTIONS[$CURRENT_POS]=0
        else
            SELECTIONS[$CURRENT_POS]=1
        fi
        show_menu
    elif [ "$char" = "" ] || [ "$char" = $'\n' ] || [ "$char" = $'\r' ]; then
        # Enter to proceed
        break
    fi
done

# Restore terminal
restore_terminal

# Check if anything is selected
TOTAL_SELECTED=0
for i in $(seq 1 $TOTAL_OPTIONS); do
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
    index=$((i + 1))
    if [ "${SELECTIONS[$index]}" -eq 1 ]; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        bash "${SCRIPT_FILES[$i]}"
        echo ""
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Build Completed!                     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

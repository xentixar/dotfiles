#!/bin/bash
# Get running applications with icons

# Icon mapping for applications (using Nerd Font icons)
# Nerd Font icon codes (Unicode)
declare -A icons=(
    # Communication
    ["slack"]=""
    ["discord"]=""
    ["telegram"]=""
    ["signal"]=""
    ["thunderbird"]=""
    
    # Media
    ["spotify"]=""
    ["vlc"]=""
    ["mpv"]=""
    
    # Browsers
    ["firefox"]=""
    ["chrome"]=""
    ["google"]=""
    ["google-chrome"]=""
    
    # Editors/IDEs
    ["code"]=""
    ["cursor"]=""
    ["obsidian"]=""
    
    # Terminals
    ["st"]=""
    ["alacritty"]=""
    ["kitty"]=""
    ["tmux"]=""
    
    # Graphics
    ["gimp"]=""
    ["inkscape"]=""
    
    # Office
    ["libreoffice"]=""
)

# Get icon for application (using Nerd Font icons)
get_app_icon() {
    local app_name="$1"
    local app_lower=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | sed 's/-.*//' | sed 's/_.*//')
    
    # Check if we have a predefined icon
    if [ -n "${icons[$app_lower]}" ]; then
        echo "${icons[$app_lower]}"
        return
    fi
    
    # Try to get icon from desktop file
    local desktop_file=""
    for dir in /usr/share/applications ~/.local/share/applications; do
        if [ -d "$dir" ]; then
            desktop_file=$(find "$dir" -name "*${app_lower}*.desktop" 2>/dev/null | head -1)
            [ -n "$desktop_file" ] && break
        fi
    done
    
    if [ -n "$desktop_file" ]; then
        local icon_name=$(grep "^Icon=" "$desktop_file" 2>/dev/null | head -1 | cut -d'=' -f2)
        if [ -n "$icon_name" ]; then
            # Map icon names to Nerd Font icons
            case "$icon_name" in
                *slack*) echo "" ;;
                *discord*) echo "" ;;
                *spotify*) echo "" ;;
                *telegram*) echo "" ;;
                *signal*) echo "" ;;
                *thunderbird*) echo "" ;;
                *firefox*) echo "" ;;
                *chrome*|*google-chrome*) echo "" ;;
                *code*|*vscode*) echo "" ;;
                *cursor*) echo "" ;;
                *obsidian*) echo "" ;;
                *gimp*) echo "" ;;
                *vlc*) echo "" ;;
                *) echo "" ;;
            esac
            return
        fi
    fi
    
    # Default icon
    echo ""
}

# Normalize app names for matching
normalize_app() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/-.*//' | sed 's/_.*//'
}

# Get visible windows (application names)
visible_apps=$(wmctrl -l 2>/dev/null | grep -v "dwm\|picom" | \
    awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}' | \
    sed 's/.* - //' | awk '{print $1}' | tr '[:upper:]' '[:lower:]' | sort -u)

# Get background processes (check for common apps)
background_apps=""
for app in slack discord spotify telegram signal-desktop thunderbird; do
    if pgrep -x "$app" > /dev/null 2>&1 || pgrep -f "$app" > /dev/null 2>&1; then
        background_apps="$background_apps $app"
    fi
done

# Also check for processes by name pattern
ps aux | grep -E "slack|discord|spotify|telegram|signal|thunderbird" | grep -v grep | \
    awk '{print $11}' | xargs -n1 basename | sort -u | while read app; do
    app_clean=$(echo "$app" | tr '[:upper:]' '[:lower:]' | sed 's/-.*//')
    case "$app_clean" in
        slack|discord|spotify|telegram|signal|thunderbird)
            background_apps="$background_apps $app_clean"
            ;;
    esac
done

# Combine and get unique apps
all_apps=$(echo -e "$visible_apps\n$background_apps" | sort -u | grep -v "^$" | tr '\n' ' ')

# Format with icons only (no text)
result=""
for app in $all_apps; do
    icon=$(get_app_icon "$app")
    if [ -n "$result" ]; then
        result="$result $icon"
    else
        result="$icon"
    fi
done

echo "$result" | head -c 100


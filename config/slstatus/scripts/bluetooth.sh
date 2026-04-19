#!/bin/sh

device_info=$(bluetoothctl info)
device_name=$(echo "$device_info" | grep "Name" | awk -F': ' '{print $2}')
battery_percentage=$(echo "$device_info" | grep -oP "Battery Percentage:.*\((\d+)\)" | awk -F'[()]' '{print $2}')

if [ -n "$device_name" ]; then
    output="$device_name"
    
    if [ -n "$battery_percentage" ]; then
        output="$output ($battery_percentage%)"
    fi
    
    echo "$output"
else
    # Non-empty so slstatus run_command does not fall back to unknown_str
    echo "-"
fi


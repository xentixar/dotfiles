#!/bin/bash

DIR=~/Pictures/screenshots
FILENAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
FULLPATH="$DIR/$FILENAME"

mkdir -p "$DIR"
scrot -s "$FULLPATH"

# Copy to clipboard
xclip -selection clipboard -t image/png -i "$FULLPATH"

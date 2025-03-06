#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CONFIG_FILE="$SCRIPT_DIR/config.txt"
RECENT_DIRS_FILE="$SCRIPT_DIR/recent_dirs.txt"

mkdir -p "$SCRIPT_DIR"
[ ! -f "$RECENT_DIRS_FILE" ] && touch "$RECENT_DIRS_FILE"

# Load recent directories
mapfile -t recent_dirs < "$RECENT_DIRS_FILE"
options=("~/Downloads" "Enter Manually" "${recent_dirs[@]}")

chosen=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Select Directory")

if [ -z "$chosen" ]; then
    exit
fi

if [ "$chosen" == "Enter Manually" ]; then
    manual_dir=$(rofi -dmenu -p "Enter Directory Path")
    
    # Expand ~ to /home/$USER
    manual_dir="${manual_dir/#~/"$HOME"}"
    
    # If input doesn't start with /, assume it's inside /home/$USER/
    if [[ "$manual_dir" != /* ]]; then
        manual_dir="$HOME/$manual_dir"
    fi

    if [ -d "$manual_dir" ]; then
        chosen="$manual_dir"
    else
        notify-send "Invalid Directory!"
        exit 1
    fi
fi

if [ "$chosen" != "~/Downloads" ]; then
    echo "$chosen" >> "$RECENT_DIRS_FILE"
    sort -u "$RECENT_DIRS_FILE" -o "$RECENT_DIRS_FILE"
fi

echo "$chosen" > "$CONFIG_FILE"
notify-send "Directory changed to: $chosen"

# test

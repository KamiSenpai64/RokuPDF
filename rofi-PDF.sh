#!/bin/bash

# RokuPDF Main Script (rofi-PDF.sh)
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CONFIG_FILE="$SCRIPT_DIR/config.txt"
LAST_OPENED_FILE=~/.config/last_opened_novel
RECENT_DIRS_FILE="$SCRIPT_DIR/recent_dirs.txt"

# Icons
declare -A ICONS=(
    [folder]='📂'
    [pdf]='📄'
    [epub]='📖'
    [star]='⭐'
    [back]='🔙'
    [change]='🔄'
)

# Get the base directory from config
if [ ! -f "$CONFIG_FILE" ]; then
    echo "~/Downloads" > "$CONFIG_FILE"
fi
BASE_DIR=$(cat "$CONFIG_FILE")

navigate() {
    local current_dir="$1"

    while true; do
        entries=()
        [ "$current_dir" != "$BASE_DIR" ] && entries+=("${ICONS[back]} ..")
        entries+=("${ICONS[change]} Change Directory")

        last_opened=""
        [ -f "$LAST_OPENED_FILE" ] && last_opened=$(cat "$LAST_OPENED_FILE")

        mapfile -t files < <(find "$current_dir" -mindepth 1 -maxdepth 1 2>/dev/null)
        for entry in "${files[@]}"; do
            [ -e "$entry" ] || continue
            name=$(basename "$entry")
            icon=""
            if [ -d "$entry" ]; then
                icon="${ICONS[folder]}"
            elif [[ "$entry" == *.pdf ]]; then
                icon="${ICONS[pdf]}"
            elif [[ "$entry" == *.epub ]]; then
                icon="${ICONS[epub]}"
            fi

            if [ "$entry" = "$last_opened" ]; then
                entries=("${ICONS[star]} $icon $name" "${entries[@]}")
            else
                entries+=("$icon $name")
            fi
        done

        chosen=$(printf "%s\n" "${entries[@]}" | rofi -dmenu -i -kb-cancel "Escape" -p "$(basename "$current_dir")")

        if [ -z "$chosen" ]; then
            [ "$current_dir" != "$BASE_DIR" ] && current_dir=$(dirname "$current_dir") || exit
            continue
        fi

        if [[ "$chosen" == *"${ICONS[back]} .."* ]]; then
            current_dir=$(dirname "$current_dir")
            continue
        fi

        if [[ "$chosen" == *"${ICONS[change]} Change Directory"* ]]; then
            "$SCRIPT_DIR/change-dir.sh"
            BASE_DIR=$(cat "$CONFIG_FILE")
            navigate "$BASE_DIR"
            return
        fi

        chosen=$(echo "$chosen" | sed "s/^${ICONS[star]} //; s/^${ICONS[folder]} //; s/^${ICONS[pdf]} //; s/^${ICONS[epub]} //")
        selected="$current_dir/$chosen"

        if [ -d "$selected" ]; then
            navigate "$selected"
        elif [[ "$selected" == *.pdf || "$selected" == *.epub ]]; then
            echo "$selected" > "$LAST_OPENED_FILE"
            setsid okular "$selected" >/dev/null 2>&1 &
            exit
        fi
    done
}

navigate "$BASE_DIR"

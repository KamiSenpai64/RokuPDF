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

        # Collect directories, PDFs, and EPUBs
        mapfile -t dirs < <(find "$current_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
        mapfile -t pdfs < <(find "$current_dir" -mindepth 1 -maxdepth 1 -iname "*.pdf" 2>/dev/null)
        mapfile -t epubs < <(find "$current_dir" -mindepth 1 -maxdepth 1 -iname "*.epub" 2>/dev/null)

        # Add directories (no sorting)
        for entry in "${dirs[@]}"; do
            name=$(basename "$entry")
            entries+=("${ICONS[folder]} $name")
        done

        # Sort PDFs and EPUBs alphabetically
        sorted_pdfs=$(printf "%s\n" "${pdfs[@]}" | sort)
        sorted_epubs=$(printf "%s\n" "${epubs[@]}" | sort)

        # If a file is the last opened, add it first (at the top of the list)
        for file in $sorted_pdfs; do
            name=$(basename "$file")
            if [ "$file" == "$last_opened" ]; then
                entries=("${ICONS[star]} ${ICONS[pdf]} $name" "${entries[@]}")
            else
                entries+=("${ICONS[pdf]} $name")
            fi
        done

        for file in $sorted_epubs; do
            name=$(basename "$file")
            if [ "$file" == "$last_opened" ]; then
                entries=("${ICONS[star]} ${ICONS[epub]} $name" "${entries[@]}")
            else
                entries+=("${ICONS[epub]} $name")
            fi
        done

        # Show files in Rofi, let the user select one
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


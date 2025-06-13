#!/bin/bash

OUT="$HOME/.config/hypr/keybinds-extra.conf"
DIR="$HOME/.config/hypr/kb"

FILES=("$DIR"/*.conf)

if [[ -e "${FILES[0]}" ]]; then
    echo "# Auto-generated includes for extra keybinds" > "$OUT"
    for file in "${FILES[@]}"; do
        echo "source = $file" >> "$OUT"
    done
fi

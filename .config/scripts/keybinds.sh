#!/bin/bash

OUT="$HOME/.config/hypr/keybinds.conf"
KB_DIR="$HOME/.config/hypr/kb"

echo "# Auto-generated includes for keybinds" >> "$OUT"
for file in "$KB_DIR"/*.conf; do
    echo "source = $file" >> "$OUT"
done

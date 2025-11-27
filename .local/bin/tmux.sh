#!/bin/bash

TMUXSP=$(hyprctl clients -j | jq -r '.[] | select(.title=="tmuxsp")')

if [ -z "$TMUXSP" ]; then
  kitty --title tmuxsp -e tmux new-session -ADs code
  exit
fi

hyprctl dispatch togglespecialworkspace tmuxsp
hyprctl dispatch resizewindowpixel exact 80% 80%,title:tmuxsp
hyprctl dispatch centerwindow

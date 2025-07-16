#!/bin/bash

TITLE="special_tmux"
SWS="special:tmux"
WIN_WS=$(hyprctl clients -j | jq -r '.[] | select(.title == "'"$TITLE"'") | .workspace.name')
CURRENT_WS=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

if [ -z "$WIN_WS" ]; then
  kitty --title "$TITLE" -e tmux new-session -ADs code
  exit
fi

if [ "$WIN_WS" == "$SWS" ]; then
  hyprctl dispatch movetoworkspace "$CURRENT_WS",title:"$TITLE"
  hyprctl dispatch resizewindowpixel exact 100 100,title:"$TITLE"
  hyprctl dispatch workspace "$CURRENT_WS"
  hyprctl dispatch resizewindowpixel exact 80% 80%,title:"$TITLE"
  hyprctl dispatch centerwindow
else
  hyprctl dispatch movetoworkspacesilent "$SWS",title:"$TITLE"
fi

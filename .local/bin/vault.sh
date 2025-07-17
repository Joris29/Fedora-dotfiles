#!/bin/bash

TITLE="special_vault"
SWS="special:vault"
WIN_WS=$(hyprctl clients -j | jq -r '.[] | select(.title == "'"$TITLE"'") | .workspace.name')
CURRENT_WS=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

if [ -z "$WIN_WS" ]; then
  kitty --title "$TITLE" -e sh -l -c 'vaul7y || read -p "Press key to exit"'
  exit
fi

if [ "$WIN_WS" == "$SWS" ]; then
  hyprctl dispatch movetoworkspace "$CURRENT_WS",title:"$TITLE"
  hyprctl dispatch resizewindowpixel exact 100 100,title:"$TITLE"
  hyprctl dispatch workspace "$CURRENT_WS"
  hyprctl dispatch resizewindowpixel exact 40% 40%,title:"$TITLE"
  hyprctl dispatch centerwindow
else
  hyprctl dispatch movetoworkspacesilent "$SWS",title:"$TITLE"
fi

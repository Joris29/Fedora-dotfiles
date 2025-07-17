#!/bin/bash

CONFIG=$HOME/.config/waybar/config

if ! pgrep -x "waybar" > /dev/null; then
    waybar &
fi

while true; do
    CURRENT_OUTPUT=$(grep '"output":' "$CONFIG" | awk -F '"' '{print $4}')
    MONITOR_COUNT=$(hyprctl monitors | grep -c 'Monitor.*')

    if [ "$MONITOR_COUNT" -gt 1 ]; then
        DESIRED_OUTPUT=$(hyprctl monitors | grep "Monitor.*(ID 1)" | awk '{print $2}')
    else
        DESIRED_OUTPUT="eDP-1"
    fi

    if [ "$CURRENT_OUTPUT" != "$DESIRED_OUTPUT" ]; then
        sed -i "s/\"output\": \".*\"/\"output\": \"$DESIRED_OUTPUT\"/" "$CONFIG"
        pkill waybar
        waybar &
    fi

    sleep 5
done

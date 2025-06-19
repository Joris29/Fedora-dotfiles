#!/bin/bash

action=$1

case "$action" in
    check)
        updates=$(dnf check-update --refresh -q | grep -c '^[a-z0-9]')

        if [ "$updates" -gt 0 ]; then
            printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system"}' "$updates" "$updates"
        else
            printf '{"text": "0", "alt": "0", "tooltip": "No updates available"}'
        fi
        ;;
    update)
        kitty sh -c 'echo "Install updates" && sudo dnf update --refresh -q && pkill waybar && hyprctl dispatch exec waybar'
        ;;
    *)
        echo "Invalid action specified. Valid options are: check and update"
        exit 1
        ;;
esac

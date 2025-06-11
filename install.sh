#!/bin/bash

declare -a DNF_PKGS=(
    'bc'
    'curl'
    'fzf'
    'git'
    'grim'
    'htop'
    'hypridle'
    'hyprland'
    'hyprlock'
    'hyprpaper'
    'hyprpolkitagent'
    'jq'
    'kitty'
    'nm-connection-editor'
    'nodejs'
    'nwg-look'
    'openssl'
    'pamixer'
    'pavucontrol'
    'playerctl'
    'python3-pip'
    'ranger'
    'rofi-wayland'
    'SwayNotificationCenter'
    'tmux'
    'unzip'
    'waybar'
    'wlogout'
    'wtype'
)

sudo dnf update -y
sudo dnf install -y "${DNF_PKGS[@]}"

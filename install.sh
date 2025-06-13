#!/bin/bash

declare -a DNF_PKGS=(
    'bc'
    'code'
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
    'nwg-look'
    'openssl'
    'pamixer'
    'pavucontrol'
    'playerctl'
    'python3-pip'
    'rofi-wayland'
    'stow'
    'SwayNotificationCenter'
    'tmux'
    'unzip'
    'waybar'
    'wlogout'
    'wtype'
)

sudo tee /etc/yum.repos.d/vscode.repo > /dev/null <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf config-manager addrepo -y --from-repofile="https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/repo/fedora-$(rpm -E %fedora)/solopasha-hyprland-fedora-$(rpm -E %fedora).repo"

sudo dnf check-update
sudo dnf install -y "${DNF_PKGS[@]}"

stow fedora -d "$HOME/dotfiles" -t "$HOME" --ignore=install.sh

#!/usr/bin/bash
set -euo pipefail

usage() {
  cat << EOF
USAGE: ${0} [-c | --config] [-r | --rofi] [-h | --help]

-c | --config  Path to your keybinds config file.
-r | --rofi    Path to your rofi config file.
-h | --help    Show this help message.
EOF
}

rofi_msg() {
  local msg="$1"
  rofi -e "$msg"
}

CONFIG="$HOME/.config/hypr/keybinds.conf"
ROFI="$HOME/.config/rofi/config.rasi"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--config)
      CONFIG="$2"
      shift 2
      ;;
    -r|--rofi)
      ROFI="$2"
      shift 2
      ;;
    -h|--help)
      rofi_msg "$(usage)"
      exit 0
      ;;
    *)
      rofi_msg "$(printf 'Unknown option: %s\n\n%s' "$1" "$(usage)")"
      exit 1
      ;;
  esac
done

if [[ ! -f "$CONFIG" ]]; then
  rofi_msg "Keybinds config file not found: $CONFIG"
  exit 1
fi

if [[ ! -f "$ROFI" ]]; then
  rofi_msg "Rofi config file not found: $ROFI"
  exit 1
fi

KEYBINDS=$(grep -E '^bind' "$CONFIG")
KEYVARS=$(grep -E '\$.*=.*' "$CONFIG")

if [[ -z "$KEYBINDS" ]]; then
  rofi_msg "no keybinds found in $CONFIG."
  exit 1
fi

echo "$KEYBINDS"
echo "$KEYVARS"

# echo "$KEYBINDS" | rofi -dmenu -i -p "Search keybind:" -config "$ROFI"

# hyprctl dispatch "$DISPATCHER" "$ACTION"

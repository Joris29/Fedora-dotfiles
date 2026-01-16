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

[[ -f "$CONFIG" ]] || { rofi_msg "Keybinds config file not found: $CONFIG"; exit 1; }
[[ -f "$ROFI" ]] || { rofi_msg "Rofi config file not found: $ROFI"; exit 1; }

declare -A VARS
while IFS='=' read -r k v; do
  [[ $k =~ ^\s*\$ ]] || continue
  VARS["$k"]="$v"
done < "$CONFIG"

KEYBINDS=$(grep -E '^bind' "$CONFIG")
KEYVARS=$(grep -E '\$.*=.*' "$CONFIG")

if [[ -z "$KEYBINDS" ]]; then
  rofi_msg "no keybinds found in $CONFIG."
  exit 1
fi

# echo "$KEYBINDS"
echo "${VARS[*]}"
echo "$KEYVARS"

echo "$KEYBINDS" | rofi -dmenu -i -p "Search keybind:" -config "$ROFI"

#####
# while IFS='=' read -r k v; do
#   [[ $k =~ ^\s*\$ ]] || continue
#   VARS["${k// /}"]="$(echo "$v" | sed 's/#.*//;s/^ *//;s/ *$//')"
# done < "$CONFIG"

# expand() {
#   local line="$1"
#   for key in "${!VARS[@]}"; do line="${line//${key}/${VARS[$key]}}"; done
#   echo "$line"
# }

# # --- Parse binds ---
# mapfile -t BINDS < <(grep -E '^\s*bind[a-z]*\s*=' "$CONFIG")
# MENU_ITEMS=()
# DISPATCHERS=()
# ARGS=()

# for raw in "${BINDS[@]}"; do
#   line=$(expand "${raw#*=}")
#   IFS=',' read -ra parts <<< "$line"
#   for i in "${!parts[@]}"; do parts[$i]=$(echo "${parts[$i]}" | xargs); done

#   # Extract modifiers, key, and remaining tokens
#   combo="${parts[0]}"
#   key="${parts[1]}"
#   rest=("${parts[@]:2}")

#   # Detect description if present (4 or more parts)
#   if (( ${#parts[@]} >= 5 )); then
#     desc="${rest[0]}"
#     dispatcher="${rest[1]}"
#     args="${rest[@]:2}"
#   else
#     desc=""
#     dispatcher="${rest[0]}"
#     args="${rest[@]:1}"
#   fi

#   combo=$(echo "$combo + $key" | sed 's/^ *+ *//;s/ *+ *$//;s/  */ /g')

#   [[ -n "$desc" ]] && label="$combo → $desc" || label="$combo → $dispatcher $args"
#   MENU_ITEMS+=("$label")
#   DISPATCHERS+=("$dispatcher")
#   ARGS+=("$args")
# done

# # --- Show menu ---
# sel=$(printf '%s\n' "${MENU_ITEMS[@]}" | rofi -dmenu -theme "$ROFI" -i -p "Keybinds") || exit 0

# # --- Run selection ---
# for i in "${!MENU_ITEMS[@]}"; do
#   [[ ${MENU_ITEMS[$i]} == "$sel" ]] || continue
#   d="${DISPATCHERS[$i]}"
#   a="${ARGS[$i]}"
#   if [[ "$d" == "exec" ]]; then
#     hyprctl dispatch exec "$a" & disown
#   else
#     hyprctl dispatch "$d" $a & disown
#   fi
#   break
# done

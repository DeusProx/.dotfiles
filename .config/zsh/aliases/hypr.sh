#!/usr/bin/env zsh

YELLOW="\033[33m"
RESET="\033[0m"

COMMAND_NOT_FOUND=127

declare -A CMD_CORRECTIONS=(
  ["Hyperland"]="Hyprland"
  ["hyperland"]="hyprland"
  ["hyperctl"]="hyprctl"
  ["hyperidle"]="hypridle"
  ["hyperland"]="hyprland"
  ["hyperlock"]="hyprlock"
  ["hyperpm"]="hyprpm"
)

# Generalized command-not-found handler
command_not_found_handler() {
  if [[ -n ${CMD_CORRECTIONS[$1]} ]]; then
    echo -e "${YELLOW}Correcting '$1' to '${CMD_CORRECTIONS[$1]}'${RESET}"
    "${CMD_CORRECTIONS[$1]}" "${@:2}"
    return
  fi
  return COMMAND_NOT_FOUND
}


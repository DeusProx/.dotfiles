#!/usr/bin/env zsh

: <<'disabled'
if typeset -f command_not_found_handler > /dev/null; then
    OLD_HANDLER=$(typeset -f command_not_found_handler)
fi

command_not_found_handler() {
  if [[ -n ${CMD_CORRECTIONS[$1]} ]]; then
    echo -e "${YELLOW}Correcting '$1' to '${CMD_CORRECTIONS[$1]}'${RESET}"
    "${CMD_CORRECTIONS[$1]}" "${@:2}"
    return $EXIT_OK
  fi

  if [[ -n "$OLD_HANDLER" ]]; then
    eval "$OLD_HANDLER" "$@"
    return $?
  fi

  return COMMAND_NOT_FOUND
}

YELLOW="\033[33m"
RESET="\033[0m"

EXIT_OK=0
EXIT_COMMAND_NOT_FOUND=127

declare -A CMD_CORRECTIONS=(
  ["Hyperland"]="Hyprland"
  ["hyperland"]="hyprland"
  ["hyperctl"]="hyprctl"
  ["hyperidle"]="hypridle"
  ["hyperland"]="hyprland"
  ["hyperlock"]="hyprlock"
  ["hyperpm"]="hyprpm"
)
disabled

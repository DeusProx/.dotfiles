# INFO: adds auto correction for certain commands for the `command_not_found_handler`

#: <<'disabled' # outcomment to disable the function handler on any problems
if typeset -f command_not_found_handler > /dev/null; then
  OLD_HANDLER=$(typeset -f command_not_found_handler)
fi

command_not_found_handler() {
  if [[ -n ${CMD_CORRECTIONS[$1]} ]]; then
    "${CMD_CORRECTIONS[$1]}" "${@:2}"
    echo -e "${YELLOW}Corrected command '$1' to '${CMD_CORRECTIONS[$1]}'${RESET}"
    return $EXIT_OK
  fi

  if [[ -n "$OLD_HANDLER" ]]; then
    eval "$OLD_HANDLER"
    eval "$@"
    return $?
  fi

  print -r -- "command not found: $@"
  return $EXIT_COMMAND_NOT_FOUND
}

YELLOW="\033[33m"
RESET="\033[0m"

EXIT_OK=0
EXIT_COMMAND_NOT_FOUND=127

# TODO: externalize this list
declare -A CMD_CORRECTIONS=(
  ["Hyperland"]="Hyprland"
  ["hyperland"]="hyprland"
  ["hyperctl"]="hyprctl"
  ["hyperidle"]="hypridle"
  ["hyperland"]="hyprland"
  ["hyperlock"]="hyprlock"
  ["hyperpm"]="hyprpm"
)
#disabled


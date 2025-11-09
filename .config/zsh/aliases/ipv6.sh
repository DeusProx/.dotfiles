# This command helps enabling/disabling ipv6

ipv6() {
  KEYS=(
    net.ipv6.conf.all.disable_ipv6
    net.ipv6.conf.default.disable_ipv6
  )
  _get() { sysctl -n "${KEYS[0]}" }
  _set() { for k in "${KEYS[@]}"; do sudo sysctl -q -w "$k=$1"; done }

  case "${1-}" in
    on) _set 0;;
    off) _set 1;;
    toggle) [[ "$(_get)" -eq 0 ]] && _set 1 || _set 0;;
    status) [[ "$(_get)" -eq 0 ]] && print -r -- "enabled" || print -r -- "disabled";;
    *) print -ru2 -- "usage: ipv6 [on|off|toggle|status]"; return 2;;
  esac
}

_ipv6_completion() {
  local actions=(
    "on:Enables ipv6"
    "off:Disables ipv6"
    "toggle:Switches then ipv6 status"
    "status:Shows the ipv6 status"
  )
  if [[ $CURRENT -eq 2 ]]; then
    _describe 'Available actions' actions
  fi
}

compdef _ipv6_completion ipv6


_vpn_usage() { /bin/cat <<EOF
vpn - the minimal vpn interface

Usage:
  'vpn'                     - list VPN profiles with status
  'vpn --help | -h'         - show this help text
  'vpn <profile>'           - toggle the given VPN (up ↔ down)
  'vpn <profile> -- <cmd>'  - up, run command, down

Example:
  'vpn home -- npm install' - connects to home vpn to install packages from npm repository in home network
EOF
}

_vpn_all()      { nmcli --terse --fields NAME,TYPE connection show          | awk -F: '$2=="vpn" {print $1}' }
_vpn_active()   { nmcli --terse --fields NAME,TYPE connection show --active | awk -F: '$2=="vpn" {print $1}' }
_vpn_is_up()    { _vpn_active | grep -Fxq -- "$1" }
_vpn_is_valid() { _vpn_all    | grep -Fxq -- "$1" }

_vpn_up()     { _vpn_is_up "$1"                                  || nmcli connection up id "$1" }
_vpn_down()   { _vpn_is_up "$1" && nmcli connection down id "$1"                                }
_vpn_toggle() { _vpn_is_up "$1" && nmcli connection down id "$1" || nmcli connection up id "$1" }

_vpn_overview() {
    local profiles=("${(@f)$(_vpn_all)}")
    if [[ ${#profiles} -eq 0 ]]; then
      echo "Error: no VPN profiles defined"
      return 1
    fi

    local len=0 new_len
    for profile in "${profiles[@]}"; do
        new_len=${#profile}
        if [[ $new_len -gt $len ]]; then
            len=$new_len
        fi
    done
    len=$((len+1))

    local connection_state
    printf "  %-${len}s %s\n" "VPN" "STATE"
    for profile in "${profiles[@]}"; do
        _vpn_is_up "$profile" && connection_state=up || connection_state=down
        printf "  %-${len}s %s\n" "$profile" "$connection_state"
    done
}

vpn() {
    if [[ $# -eq 0 ]]; then
        _vpn_overview
        return
    fi

    if [[ $# -eq 1 && ( $1 == --help || $1 == -h ) ]]; then
        _vpn_usage
        return
    fi

    local profile=$1
    shift
    if ! _vpn_is_valid "$profile"; then
        echo "Error: Unknown profile '$profile'"
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        _vpn_toggle "$profile"
        return
    fi

    if [[ $1 != -- ]]; then
        echo "Error: expected '--' before the command"
        echo " Hint: vpn <profile> -- <command>"
        return 1
    fi
    shift
    local command=$@
    if [[ ! $command ]]; then
        echo "Error: expected command after '--'"
        echo " Hint: vpn <profile> -- <command>"
        return 1
    fi

    # run command within vpn
    local command_status
    _vpn_up "$profile" || {
        echo "Error: could not activate to $profile"
        return 1
    }
    $command
    command_status=$?
    _vpn_down "$profile"

    return $command_status
}

_vpn_completion() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1:VPN profile:->profile' \
        '2:separator:->separator' \
        '3:command:->cmd' \
        '*:command arguments:->arguments'

    case $state in
        profile)
            _values -w 'flags' --help -h
            local profiles=("${(@f)$(_vpn_all)}")
            _describe -t profiles 'VPN profiles' profiles
            ;;
        separator)
            _values -w 'separator' --
            ;;
        cmd)
            _command_names -e
            ;;
        arguments)
            # drop “vpn <profile> --” so only the command is left
            shift 3 words
            (( CURRENT -= 3 ))
            _normal
            ;;
    esac
}

compdef _vpn_completion vpn


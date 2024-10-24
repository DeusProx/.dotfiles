#!/bin/sh

# simpler commands to handle vpn connections
vpn() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: vpn <name> <up|down>"
        return 1
    fi

    local vpn_name=$1
    local action=$2

    if ! nmcli connection show | grep -q "^$vpn_name"; then
        echo "Error: vpn '$vpn_name' not found."
        return 1
    fi

    if [[ $action == "up" ]]; then
        nmcli connection up id "$vpn_name"
    elif [[ $action == "down" ]]; then
        nmcli connection down id "$vpn_name"
    else
        echo "Invalid action. Use 'up' or 'down'."
        return 1
    fi
}

_vpn_completion() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    local -a vpn_list action_list

    vpn_list=($(nmcli connection show | awk '$3=="vpn" {print $1}'))
    action_list=(up down)

    # Case to complete based on argument position
    _arguments \
        '1:vpn name:->vpn' \
        '2:action:->action'

    case $state in
        vpn)
            _describe -t vpn 'vpn name' vpn_list
            ;;
        action)
            _describe -t action 'action' action_list
            ;;
    esac
}

# bind completion function
compdef _vpn_completion vpn

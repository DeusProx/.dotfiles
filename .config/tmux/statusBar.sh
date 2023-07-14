#!/usr/bin/env bash

function active_window () {
  echo "$(window '#EEEEEE')"
}

function inactive_window () {
  echo "$(window '#999999')"
}

function window() {
  local sep=$([[ "$5" == "l" ]] && echo "" || echo "")
  local inv_sep=$([[ "$5" == "l" ]] && echo "" || echo "" )
  local sep1="#[bg=default,fg=${1}]${sep}"
  local sep2="#[bg=$1,     fg=${2}]${sep}"
  local sep3="#[bg=default,fg=${2}]${inv_sep}"

  # Just a fancy collection if I want to change it up
  #
  #    
  #    
  #    
  #    
  #    
  #
  # local sep1="#[bg=default,fg=$1] "
  # local sep2="#[bg=$1,     fg=$2]▐"
  # local sep3="#[bg=default,fg=$2] "

  local icon="#[bg=$1,fg=#e6e6e6]${3}"
  local text="#[bg=$2,fg=#e6e6e6]${4}"
  echo "${sep1}${icon}${sep2}${text}${sep3}#[none]"
}

function w {
  echo "$(window "#4d994d" "#66b366"  "$1" "$2" "$3")"
}
function wr {
  echo "$(w "$1" "$2" "r")"
}
function wl {
  echo "$(w "$1" "$2" "l")"
}

tmux set-window-option -g window-status-current-format "$(window '#AA44AA' '#CC88CC' '#I' ' #W' 'l')" # active window
tmux set-window-option -g window-status-format         "$(window '#AAAAAA' '#888888' '#I' ' #W' 'l')" # inactive window

# Left status bar
tmux set -g status-left ''                 # Clear
tmux set -ag status-left "$(wl " " "#I")" # Show a nice rocket
tmux set -ag status-left "$(wl " " "#S")" # Show current session

# Right status bar
tmux set -g status-right ''                                            # Clear
tmux set -ag status-right "$(wr " " "#h")"                            # Username
tmux set -ag status-right \
  "$(wr "󱦂 " "#(ifconfig enp5s0 | grep 'inet ' | awk '{print \$2}')")" # Ip
tmux set -ag status-right \
  "$(wr "󱦟 " "#(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',')")"       # Uptime
tmux set -ag status-right "$(wr " " "%a,%d %b %Y")"                   # Current date
tmux set -ag status-right "$(wr " " "%H:%M")"                         # Current time


# INFO: Wrapper for tmux so it always tries to attach first

function tmux {
  if [ $# -eq 0 ]; then
    command tmux a || command tmux n
  else
    command tmux "$@"
  fi
}


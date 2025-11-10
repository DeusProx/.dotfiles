# This script is wrapper for git to redefine/extend functionality.
# Currently only the `--date` handling of the `commit` subcommand is redefined.
#
# Use at your own peril!

git_command=/usr/bin/git

function git {
  case $1 in
    commit) shift; git_commit "$@";;
    *) $git_command "$@";;
  esac
}

# Usually --date only sets the `GIT_COMMITER_DATE`,
# but we also want to set the `GIT_AUTHOR_DATE`.
function git_commit {
  date_arg=""
  args=()

  while  (($#)); do
    case "$1" in
      --date=*) date_arg="${1#--date=}";;
      --date)
        if [[ $# -ge 2 ]]; then
          date_arg="$2"
          shift
        else
          echo "fatal: date value missing" >&2
          return 1
        fi
        ;;
      --) shift; args+=("$@"); break;;
      *) args+=("$1");;
    esac
    shift
  done

  if [[ -z $date_arg ]]; then
    $git_command commit "${args[@]}"
    return 0
  fi

  if ! date_timestamp=$(date -d "$date_arg" 2>/dev/null); then
    echo "fatal: invalid date format: $date_arg" >&2
    return 2
  fi


  GIT_AUTHOR_DATE="\"$date_timestamp\"" GIT_COMMITTER_DATE="\"$date_timestamp\"" \
    "$git_command" commit "${args[@]}"
}


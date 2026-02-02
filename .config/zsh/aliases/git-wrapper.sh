# INFO:
#   This script is wrapper for git to redefine/extend functionality.
#   Currently only the `--date` handling of the `commit` subcommand is redefined.
#   Everything else is just passed through.
#
#  WARN: Use at your own peril!

function git {
  case $1 in
    commit) shift; git_commit "$@";;
    *) command git "$@";;
  esac
}

# INFO:
#   Usually --date only sets the `GIT_COMMITER_DATE`,
#   but we also want to set the `GIT_AUTHOR_DATE`.
function git_commit {
  date_arg=""
  args=()

  while (($#)); do
    case "$1" in
      --date=*) date_arg="${1#--date=}";;
      --date)
        if [[ $# -ge 2 ]]; then
          date_arg="$2"
          shift
        else
          echo "fatal: date value not specified" >&2
          return 1
        fi
        ;;
      --) shift; args+=("$@"); break;;
      *) args+=("$1");;
    esac
    shift
  done

  if [[ -z $date_arg ]]; then
    command git commit "${args[@]}"
    return 0
  fi

  if ! date_timestamp=$(date -d "$date_arg" --rfc-email 2>/dev/null); then
    echo "fatal: invalid date format: $date_arg" >&2
    return 2
  fi

  # TODO: (Optional?) Add check so that the date of the current commit is not earlier than the last commit

  GIT_AUTHOR_DATE="\"$date_timestamp\"" GIT_COMMITTER_DATE="\"$date_timestamp\"" \
    command git commit "${args[@]}"
}


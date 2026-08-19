#!/usr/bin/env zsh

# INFO: [sh]ell [d]e[b]ug - Run shell script functions for debugging purposes
# WARN: Be aware that global state will not be created and used correctly

typeset -g _SHDB_HELPER_DIR="${${(%):-%N}:A:h}/shdb"


_shdb_usage() {
    echo "Usage: shdb <script> [function] [args...]"
}


_shdb_shell_for() {
    local script="$1"
    local shebang

    shebang="$(head -n1 -- "$script" 2>/dev/null)"

    case "$shebang" in
        *zsh*)  echo zsh ;;
        *bash*) echo bash ;;
        *)
            case "$script" in
                *.zsh) echo zsh ;;
                *)     echo bash ;;
            esac
            ;;
    esac
}


_shdb_call() {
    local script="$2"

    case "$(_shdb_shell_for "$script")" in
        bash)
            command bash --noprofile --norc \
                "$_SHDB_HELPER_DIR/shdb-bash" "$@"
            ;;

        zsh)
            command zsh -f \
                "$_SHDB_HELPER_DIR/shdb-zsh" "$@"
            ;;
    esac
}


shdb() {
    if (( $# < 1 )); then
        _shdb_usage
        return 1
    fi

    local script="$1"
    shift

    if [[ ! -f "$script" ]]; then
        echo "error: script not found: $script" >&2
        return 1
    fi

    if (( $# == 0 )); then
        _shdb_call functions "$script"
        return
    fi

    local fn="$1"
    shift

    _shdb_call run "$script" "$fn" "$@"
}


_shdb() {
    if (( CURRENT == 2 )); then
        _files
        return
    fi

    if (( CURRENT == 3 )); then
        local script="${words[2]}"
        local -a funcs

        [[ -f "$script" ]] || return

        funcs=("${(@f)$(_shdb_call functions "$script" 2>/dev/null)}")

        _describe 'function' funcs
        return
    fi

    _files
}
compdef _shdb shdb


#!/usr/bin/env bash

# INFO:
#   This script shows a list of all the alias subcommands you have defined in your git config
#   To add descriptions create an `[alias-description]` area in your git config like this:
#
#   [alias-description]
#       alias = "lists all defined alias functions with a description"
#       ...
#

NAMES=$(
  git config --get-regexp '^alias\.' | \
  cut -d'.' -f2 | \
  cut -d' ' -f1 | \
  sort
)

MAX=$(
  printf '%s\n' $NAMES | \
  awk '{print length}' | \
  sort -nr | \
  head -1
)

mapfile -t LINES < <(git config --get-regexp '^alias-description\.')
declare -A DESC
for LINE in "${LINES[@]}"; do
  read -r KEY TEXT <<< "$LINE"
  DESC["${KEY#alias-description.}"]="$TEXT"
done

echo "Your git config defines following git alias:"
echo
for NAME in $NAMES; do
  printf "  %${MAX}s → %s\n" "$NAME" "${DESC[$NAME]:-(no description)}"
done


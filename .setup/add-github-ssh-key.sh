#!/usr/bin/env bash
set -euo pipefail

# This script helps creating and uploading ssh keys to github

# dependencies
# sudo pacman -Sy --noconfirm --needed git openssh github-cli inetutils

WHO="git:$(whoami)@$(hostname)"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519_git"
PUB_PATH="$KEY_PATH.pub"
KNOWN_HOSTS_PATH="$SSH_DIR/known_hosts"

main() {
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  ensure_git_key
  ensure_github_is_known

  git_auth
  upload_key

  echo "Done. Run \"ssh -T git@github.com\" to make sure everything worked!"
}

ensure_git_key() {
  if [[ ! -f "$KEY_PATH" || ! -f "$PUB_PATH" ]]; then
    generate_git_key
  else
    printf "%s already exists. Overwrite? [y/N] " "$KEY_PATH"
    read -r ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      rm "$KEY_PATH" "$PUB_PATH"
      generate_git_key
    fi
  fi
}

generate_git_key() {
  printf "Enter passphrase (empty for none): "
  read -rs pass; echo
  ssh-keygen -t ed25519 -a 100 -o -N "$pass" -C "$WHO" -f "$KEY_PATH"
  ssh-add $KEY_PATH # make known in ssh agent
}

ensure_github_is_known() {
  scan="$(ssh-keyscan -T 5 -t rsa,ecdsa,ed25519 -H github.com 2>/dev/null | sed '/^#/d')"
  touch "$KNOWN_HOSTS_PATH"; chmod 600 "$KNOWN_HOSTS_PATH" 2>/dev/null || true

  while IFS= read -r line; do
    set -- $line # line format: <host_or_hash> <type> <base64> [comment]
    if ! grep -Fq " $2 $3" "$KNOWN_HOSTS_PATH"; then
      printf '%s\n' "$line" >> "$KNOWN_HOSTS_PATH"
    fi
  done <<< "$scan"
}

git_auth() {
  gh auth status --hostname github.com &>/dev/null \
    || gh auth login --hostname github.com --git-protocol ssh --web --scopes admin:public_key
}

upload_key() {
  LOCAL_K="$(cut -d' ' -f1-2 "$PUB_PATH")"
  REMOTE_K="$(gh api /user/keys --jq '.[] | select(.title=="'"$WHO"'") | .key | split(" ")[0:2] | join(" ")' | head -n1 || true)"
  RID="$(gh api /user/keys --jq '.[] | select(.title=="'"$WHO"'") | .id' | head -n1 || true)"

  if [[ "$REMOTE_K" == "$LOCAL_K" ]]; then
    echo "GitHub key up-to-date (title: $WHO)."
    return
  fi

  if [[ -z "$RID" ]]; then
    gh api --method POST /user/keys -f title="$WHO" -f key="$(<"$PUB_PATH")" >/dev/null
    echo "Uploaded key \"$WHO\" to GitHub."
  else
    gh api --method DELETE "/user/keys/$RID" >/dev/null
    gh api --method POST /user/keys -f title="$WHO" -f key="$(<"$PUB_PATH")" >/dev/null
    echo "Replaced key \"$WHO\" on GitHub."
  fi
}

main


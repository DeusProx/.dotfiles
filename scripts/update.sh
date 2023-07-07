#!/bin/bash
# Helps keeping everything updated
#
# Hint:
#   This script is incomplete.
#   Do not think everything will work after running this.
#

# package manager

# system
sudo apt update
sudo apt upgrade

# rust
rustup update
cargo install-update -a

# node/npm
#   source: https://gist.github.com/othiym23/4ac31155da23962afd0e
npm install -g npm@latest

set -x

for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
do
    npm -g install "$package"
done

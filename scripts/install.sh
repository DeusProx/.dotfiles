#!/bin/bash
# Helps installing everything
#
# Hint:
#   This script is incomplete.
#   Do not think everything will work after running this.
#

# package manager

## system
sudo apt update
sudo apt upgrade

## rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-update

# preparation

## add repositories
sudo add-apt-repository ppa:neovim-ppa/unstable

## update for added repositories
sudo apt update

## general tools
sudo apt install software-properties-common

# tools

## cargo tools
cargo install alacritty    # current fav terminal; TODO: fix bash completion
cargo install gitui        # git app for terminal
cargo install exa          # ls with highlighting
cargo install --locked bat # cat with highlighting
cargo install loc          # counts lines in files
cargo install tokei        # also counts lines in files

## tmux
sudo apt install tmux \
  entr # for tmux-autoreload plugin to watch the config file

## Add the actual repositories

## Finally add applications from repositories
sudo apt update
sudo apt install neovim

## neovim plugins
sudo apt install ripgrep
sudo apt install fd-find
npm install -g tree-sitter-cli
npm install -g neovim
# cargo install tree-sitter-cli # alternative to previous line


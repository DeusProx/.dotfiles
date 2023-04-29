#!/bin/bash
# Helps installing everything
#
# Hint:
#   This script is incomplete.
#   Do not think everything will work after running this.
#

# Add apt repositories

## Preparation
sudo apt-get install software-properties-common

## Add the actual repositories
sudo add-apt-repository ppa:neovim-ppa/unstable

## Finally add applications from repositories 
sudo apt-get update
sudo apt-get install neovim


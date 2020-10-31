#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# neovim
mkdir -p ~/.config
ln -s $SCRIPT_DIR/.config/nvim ~/.config/nvim
ln -s $SCRIPT_DIR/.config/dein ~/.config/dein

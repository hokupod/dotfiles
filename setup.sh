#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# neovim
mkdir -p ~/.config
ln -s $SCRIPT_DIR/.config/nvim ~/.config/nvim
# vim
mkdir -p ~/.vim
ln -s $SCRIPT_DIR/.vimrc ~/.vimrc
ln -s $SCRIPT_DIR/.vim/_config ~/.vim/_config
ln -s $SCRIPT_DIR/.vim/ftplugin ~/.vim/ftplugin
ln -s $SCRIPT_DIR/.vim/filetype.vim ~/.vim/filetype.vim

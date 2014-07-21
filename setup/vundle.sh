#!/bin/sh
TOP="$(cd "$(dirname "$0")/../"; pwd)"

# Vundle Plugin
if [ ! -d "${TOP}/bundle/Vundle.vim" ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ${TOP}/bundle/Vundle.vim
fi
vim -c PluginInstall

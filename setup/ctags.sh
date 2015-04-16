#!/bin/sh

if hash brew 2>/dev/null; then
    brew install ctags
else
    # sudo apt-get install ctags
    sudo apt-get install exuberant-ctags
fi

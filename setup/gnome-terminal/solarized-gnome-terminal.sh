#!/bin/sh

git clone git://github.com/seebi/dircolors-solarized.git
cp dircolors-solarized/dircolors.256dark ~/.dircolors
eval 'dircolors ~/.dircolors'

git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git
gnome-terminal-colors-solarized/install.sh

rm -rf dircolors-solarized/ gnome-terminal-colors-solarized/

#!/bin/sh
cd "$(dirname "$0")"

cp fonts/* ~/.fonts
fc-cache -vf ~/.fonts

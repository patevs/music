#!/bin/bash

#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ cirrus <cirrus@archlinux.info>
# ░▓ code   ▓ https://gist.github.com/cirrusUK
# ░▓ mirror ▓ http://cirrus.turtil.net
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
tput setaf 5
echo -n "enter the url of mp3 you wish to download:"
read url
url="$url"
tput setaf 6
youtube-dl  -c --restrict-filenames --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$(xclip -selection clipboard -o | cut -d\& -f1)" "$url"
tput setaf 2
echo -n " yay ! your mp3 will be in directory from where you ran this script"

# EOF #

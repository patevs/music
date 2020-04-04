#!/usr/bin/env bash

# deps: sacad feh fancy_audio [rubygem]
# opt deps: optipng jpegoptim

tput setaf 5
read -p "enter name of artist album art: " artist
tput setaf 1
read -p "enter name of the album requiring art: " album
tput setaf 6
~/venv/bin/sacad -v normal "${artist}" "${album}" 150  ~/"${album}.jpg"
read -p "View Downloaded Album Art $fehview? [yn] " answer
if [[ $answer = y ]] ; then
fehview=$(feh ~/"${album}.jpg" )
fi
tput setaf 2
read -p "enter path of .mp3 file to embed art: " embed
fancy_audio  "${embed}"  ~/"${album}.jpg"
tput setaf 3
echo -n " yay ! "${album}.jpg" now embedded into "${embed}" "
echo ''
read -p "Delete Downloaded Album Art $artdel? [yn] " answer
if [[ $answer = y ]] ; then
artdel=$(rm ~/"${album}.jpg" )
fi

# EOF #

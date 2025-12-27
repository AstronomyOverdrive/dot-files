#!/bin/sh

rm -f $HOME/.yttemp/*
cd $HOME/.yttemp/
yt-dlp $1
mpv "$(ls)"

exit 0

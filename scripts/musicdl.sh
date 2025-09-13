#!/bin/sh

cd $HOME/Music/
yt-dlp --restrict-filenames --yes-playlist -x -o "%(uploader)s/%(playlist)s/%(uploader)s-%(playlist)s-%(playlist_index)s-%(title)s.%(ext)s" --audio-format opus --embed-metadata --parse-metadata "playlist_index:%(track_number)s" --add-metadata $1

exit 0

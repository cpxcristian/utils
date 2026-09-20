#!/bin/bash

# Play - /home/cristian/.local/bin/MusicBee.sh play-pause PlayPause

if pgrep -f "MusicBee.exe" > /dev/null; then
    wine "C:\Program Files\MusicBee\MusicBee.exe" /$2
else
    playerctl $1
fi

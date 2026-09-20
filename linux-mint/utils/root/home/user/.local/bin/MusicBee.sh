#!/bin/bash

# Play - /home/cristian/.local/bin/MusicBee.sh play-pause PlayPause
# Play - /home/cristian/.local/bin/MusicBee.sh next Next
# Play - /home/cristian/.local/bin/MusicBee.sh previous Previous
BOTELLA="MusicBee"

if pgrep -f "MusicBee.exe" > /dev/null; then
    export WINEPREFIX="$HOME/.var/app/com.usebottles.bottles/data/bottles/bottles/$BOTELLA"
    flatpak run --command=wine com.usebottles.bottles "C:\Program Files (x86)\MusicBee\MusicBee.exe" /$2
else
    playerctl $1
fi
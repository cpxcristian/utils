#!/bin/bash
cp --update=none /usr/share/applications/*.desktop ~/.local/share/applications/
cp --update=none /var/lib/flatpak/exports/share/applications/*.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/*.desktop

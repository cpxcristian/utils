#!/bin/bash

EMBLEMA="$1"
shift

if [ -z "$EMBLEMA" ]; then
    exit 1
fi

for f in "$@"; do
    current_str=$(gio info -a metadata::emblems "$f" | grep "metadata::emblems:" | sed 's/.*\[//; s/\]//; s/,//g')
    read -r -a emblems_array <<< "$current_str"

    if [[ " ${emblems_array[*]} " == *" $EMBLEMA "* ]]; then
        continue
    fi

    emblems_array+=("$EMBLEMA")
    gio set -t stringv "$f" metadata::emblems "${emblems_array[@]}"
done

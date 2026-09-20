#!/bin/bash

IFS=$'\n'

find . -type f -name "*.mp3" | while read -r file; do
    echo "Processing: $file"
    year=$(ffprobe -v error -show_entries format_tags=date -of default=noprint_wrappers=1:nokey=1 "$file")
    echo $year

    if [ ! -z "$year" ]; then
        temp_file="${file%.mp3}_temp.mp3"
        ffmpeg -i "$file" -metadata comment="$year" -c:a copy "$temp_file" -y -loglevel error
        mv "$temp_file" "$file"
        echo "-> Success: Year '$year' copied to comment."
    else
        echo "-> Skipped: No 'date' tag found."
    fi
    echo "--------------------------------------"
done

echo "Process completed successfully!"

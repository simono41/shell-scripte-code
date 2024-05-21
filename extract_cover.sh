#!/bin/bash

set -e

# Durchlaufe alle Verzeichnisse
for dir in */; do
    # Gehe ins Verzeichnis
    cd "$dir" || continue

    # Finde die erste Musikdatei (sortiert nach Name)
    first_music_file=$(find . -maxdepth 1 -type f \( -name "*.mp3" -o -name "*.flac" -o -name "*.m4a" -o -name "*.opus" \) | sort | head -n 1)

    # Wenn eine Musikdatei gefunden wurde
    if [[ -n "$first_music_file" ]]; then
        # Extrahiere das Coverbild
        ffmpeg -i "$first_music_file" -an -vcodec copy folder.jpg
    fi

    # Gehe zurück ins Ausgangsverzeichnis
    cd ..
done

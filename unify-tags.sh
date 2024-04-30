#!/bin/bash

set -x

# Pfad zum Basisverzeichnis der Musikdateien
BASE_DIR="/media/music/Soundtracks"

# Sammle alle Verzeichnisse
directories=($(find "$BASE_DIR" -type d -print))

# Gehe durch jedes Unterverzeichnis
for dir in "${directories[@]}"; do
    echo "Verarbeite Verzeichnis: $dir"
    # Initialisiere ein Assoziativ-Array für Künstlerzählungen
    declare -A artist_count

    # Finde alle Opus-Dateien im aktuellen Verzeichnis und lese die Artist-Tags
    #while IFS= read -r -d $'\0' file; do
    #    artist=$(ffprobe -v error -show_entries stream_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
    #    if [[ -n "$artist" ]]; then
    #        ((artist_count["$artist"]++))
    #    fi
    #done < <(find "$dir" -maxdepth 1 -type f -name '*.opus' -print0)

    # Finde alle Opus-Dateien im aktuellen Verzeichnis und lese die Artist-Tags
    while IFS= read -r -d $'\0' file; do
        artist=$(opusinfo "$file" 2>/dev/null | grep -oP 'artist=\K.*')
        if [[ -n "$artist" ]]; then
            ((artist_count["$artist"]++))
        fi
    done < <(find "$dir" -maxdepth 1 -type f -name '*.opus' -print0)

    # Finde den am häufigsten vorkommenden Artist
    max_count=0
    common_artist=""
    for artist in "${!artist_count[@]}"; do
        if [[ ${artist_count[$artist]} -gt $max_count ]]; then
            max_count=${artist_count[$artist]}
            common_artist=$artist
        fi
    done

    # Setze den häufigsten Artist-Tag für alle Dateien im Verzeichnis
    if [[ -n "$common_artist" ]]; then
        echo "Häufigster Künstler in '$dir' ist: $common_artist"
        find "$dir" -maxdepth 1 -type f -name '*.opus' -exec bash -c 'ffmpeg -i "$0" -c copy -metadata:s artist="'"$common_artist"'" "${0%.opus}_new.opus" && mv "${0%.opus}_new.opus" "$0"' {} \;
    else
        echo "Kein Künstler gefunden in '$dir'"
    fi

    # Lösche das Assoziativ-Array für das nächste Verzeichnis
    unset artist_count
done

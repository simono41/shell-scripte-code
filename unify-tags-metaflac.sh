#!/bin/bash

set -x

# Pfad zum Basisverzeichnis der Musikdateien
BASE_DIR="/media/music/Test-Gaming-Soundtracks"

# Sammle alle Verzeichnisse
directories=($(find "$BASE_DIR" -type d -print))

# Gehe durch jedes Unterverzeichnis
for dir in "${directories[@]}"; do
    echo "Verarbeite Verzeichnis: $dir"
    # Initialisiere ein Assoziativ-Array für Künstlerzählungen
    declare -A artist_count

    # Finde alle FLAC-Dateien im aktuellen Verzeichnis und lese die Artist-Tags
    while IFS= read -r -d $'\0' file; do
        artist=$(metaflac --show-tag=ARTIST "$file" | sed 's/ARTIST=//')
        if [[ -n "$artist" ]]; then
            ((artist_count["$artist"]++))
        fi
    done < <(find "$dir" -maxdepth 1 -type f -name '*.flac' -print0)

    # Finde den am häufigsten vorkommenden Artist
    max_count=0
    common_artist=""
    for artist in "${!artist_count[@]}"; do
        if [[ ${artist_count[$artist]} -gt $max_count ]]; then
            max_count=${artist_count[$artist]}
            common_artist=$artist
        fi
    done

    # Setze den häufigsten Artist-Tag für alle Dateien im Verzeichnis und füge ReplayGain hinzu
    if [[ -n "$common_artist" ]]; then
        echo "Häufigster Künstler in '$dir' ist: $common_artist"
        find "$dir" -maxdepth 1 -type f -name '*.flac' -print0 | while IFS= read -r -d $'\0' file; do
            metaflac --remove-tag=ARTIST "$file"
            metaflac --set-tag=ARTIST="$common_artist" "$file"
            # Entferne vorhandene ReplayGain-Tags
            metaflac --remove-replay-gain "$file"
            # Berechne und füge neue ReplayGain-Tags hinzu
            metaflac --add-replay-gain "$file"
        done
    else
        echo "Kein Künstler gefunden in '$dir'"
    fi

    # Lösche das Assoziativ-Array für das nächste Verzeichnis
    unset artist_count
done

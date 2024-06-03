#!/bin/bash

set -ex

# Funktion zum Hinzufügen des Tags zu einer .flac-Datei
add_tag() {
    local file="$1"
    metaflac --remove-tag=COMPILATION "$file"
    metaflac --set-tag=COMPILATION=1 "$file"
}

# Finde alle .flac-Dateien rekursiv und füge das Tag hinzu
find . -type f -name "*.flac" -print0 | while IFS= read -r -d '' file; do
    echo "Processing file: $file"
    add_tag "$file"
done

echo "Done."

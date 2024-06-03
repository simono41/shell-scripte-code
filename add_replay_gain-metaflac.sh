#!/bin/bash

set -ex

# Funktion zum Hinzufügen von Replay Gain zu einer einzelnen Datei
add_replay_gain() {
    local file="$1"
    echo "Processing $file"
    metaflac --add-replay-gain "$file"
}

# Funktion zum rekursiven Durchsuchen von Verzeichnissen
process_directory() {
    local dir="$1"
    find "$dir" -type f -name "*.flac" -print0 | while IFS= read -r -d '' file; do
        add_replay_gain "$file"
    done
}

# Startverzeichnis (Standardmäßig das aktuelle Verzeichnis)
start_dir="${1:-.}"

# Verzeichnis verarbeiten
process_directory "$start_dir"

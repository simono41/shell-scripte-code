#!/bin/bash

# Funktion zum Extrahieren der linken Port-Bereiche aus docker-compose.yml-Dateien
extract_ports() {
    local file=$1
    # Verwende grep und awk, um die linken Port-Bereiche zu extrahieren
    grep -E '^\s*- "?[0-9]+:[0-9]+"' "$file" | awk -F '[:-]' '{print $2}'
}

# Rekursive Suche nach docker-compose.yml-Dateien und Extraktion der Ports
find . -name "docker-compose.yml" | while read -r file; do
    echo "Datei: $file"
    extract_ports "$file"
done

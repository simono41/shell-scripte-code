#!/bin/bash

set -ex

# Durchlaufe alle Dateien im aktuellen Verzeichnis
for file in *; do
    # Überprüfe, ob es sich um eine Datei handelt und nicht um ein Verzeichnis
    if [ -f "$file" ]; then
        # Extrahiere den Dateinamen ohne die Endung
        filename=$(basename "$file" | sed 's/\(.*\)\..*/\1/')
        
        # Erstelle einen Ordner mit dem extrahierten Namen, falls nicht vorhanden
        mkdir -p "$filename"
        
        # Verschiebe die Datei in den erstellten/ vorhandenen Ordner
        mv "$file" "$filename/"
    fi
done

echo "Dateien wurden erfolgreich sortiert."

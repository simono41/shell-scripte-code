#!/bin/bash

# Navigieren Sie zum Verzeichnis mit den ZIP-Dateien
cd $1

# Iterieren über jede ZIP-Datei im aktuellen Verzeichnis
for z in *.zip; do
    # Bestimmen des Zielverzeichnisses basierend auf dem ZIP-Dateinamen (ohne die .zip-Erweiterung)
    dir="${z%.*}"

    # Überprüfen des Inhalts des ZIP-Archivs
    contains_folder=$(unzip -l "$z" | grep '/' | wc -l)

    # Entscheiden, ob ein Verzeichnis erstellt werden soll oder nicht
    if [[ $contains_folder -gt 0 ]]; then
        echo "Das Archiv $z enthält bereits Verzeichnisse. Entpacken im aktuellen Verzeichnis."
        unzip -d "$dir" "$z"
    else
        echo "Das Archiv $z enthält keine Verzeichnisse. Entpacken in einem neuen Verzeichnis $dir."
        mkdir -p "$dir"
        unzip -d "$dir" "$z"
    fi
done

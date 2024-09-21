#!/bin/bash

set -ex

# Startdatum und Enddatum festlegen
start_date="2017-06-29"
end_date="2024-09-19"

# Schleife über alle Daten im wöchentlichen Rhythmus
current_date=$start_date
while [[ "$(date -d "$current_date" +%s)" -le "$(date -d "$end_date" +%s)" ]]; do
    # URL generieren
    url="https://pad.stratum0.org/p/dc-$current_date/export/markdown"
    
    # Temporärer Dateiname
    temp_file="temp_dc-$current_date.md"
    
    # Datei herunterladen
    wget "$url" -O "$temp_file" -q
    
    # Überprüfen der Dateigröße
    if [[ -f "$temp_file" && $(stat -c%s "$temp_file") -gt 454 ]]; then
        # Datei umbenennen, wenn sie größer als 454 Bytes ist
        mv "$temp_file" "dc-$current_date.md"
        echo "Datei dc-$current_date.md erfolgreich heruntergeladen und gespeichert."
    else
        # Datei löschen, wenn sie nicht existiert oder zu klein ist
        rm -f "$temp_file"
        echo "Datei dc-$current_date.md nicht verfügbar oder zu klein."
    fi
    
    # Datum um eine Woche erhöhen
    current_date=$(date -I -d "$current_date + 7 days")
done

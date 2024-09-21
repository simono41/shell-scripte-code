#!/bin/bash

set -ex

# Startdatum und Enddatum festlegen
start_date="2017-06-29"
end_date="2024-09-19"

# Schleife über alle Daten im zweiwöchigen Rhythmus
current_date=$start_date
while [[ "$current_date" < "$end_date" ]]; do
    # URL generieren
    url="https://pad.stratum0.org/p/dc-$current_date/export/markdown"
    
    # Datei herunterladen und mit angepasstem Namen speichern
    wget "$url" -O "dc-$current_date.md"
    
    # Datum um zwei Wochen erhöhen
    current_date=$(date -I -d "$current_date + 14 days")
done

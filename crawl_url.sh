#!/bin/bash

base_url="https://pad.stratum0.org/p/dc/export/txt"
depth=${1:-3}  # Suchtiefe als Parameter, Standard ist 3
user_agent="Mozilla/5.0 (compatible; EtherpadCrawler/1.0)"
delay=0  # Verzögerung zwischen Anfragen in Sekunden

# Funktion zum Crawlen einer URL
crawl_url() {
    local url=$1
    local current_depth=$2

    if [ $current_depth -gt $depth ]; then
        return
    fi

    echo "Durchsuche: $url"

    # Verwende curl mit Fehlerbehandlung und User-Agent
    response=$(curl -s -A "$user_agent" -m 30 "$url")
    if [ $? -ne 0 ]; then
        echo "Fehler beim Abrufen von $url"
        return
    fi

    # Extrahiere Links effizienter
    links=$(echo "$response" | grep -oP '(href="|)https?://pad\.stratum0\.org/p/dc-[^"\s]+' | sed 's/^href="//g')

    for link in $links; do
        echo "Gefunden: $link"
        # Verzögerung zwischen Anfragen
        sleep $delay
        crawl_url "$link" $((current_depth + 1)) &
    done
}

# Starte den Crawl-Prozess
crawl_url "$base_url" 1
wait  # Warte auf alle Hintergrundprozesse

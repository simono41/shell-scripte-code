#!/bin/bash

set -x

# Name der Eingabedatei
input_file="$1"
output_with_arbeit="with_arbeit.json"
output_without_arbeit="without_arbeit.json"

# Extrahiere die IDs der Sammlungen, die das Wort "Arbeit" im Namen enthalten
arbeit_collections=$(jq -r '.folders[] | select(.name | contains("Arbeit")) | .id' "$input_file")

# Initialisiere die Ausgabedateien
echo '{"items": []}' > "$output_with_arbeit"
echo '{"items": []}' > "$output_without_arbeit"

# Durchlaufe alle Items in der JSON-Datei
jq -c '.items[]' "$input_file" | while read -r item; do
  # Hol die Collection ID des Items
  folder_id=$(echo "$item" | jq -r '.folderId')

  # Überprüfe, ob das Item zu einer Sammlung gehört, die "Arbeit" im Namen hat
  match_found=false
  for arbeit_id in $arbeit_collections; do
    if [[ "$folder_id" == "$arbeit_id" ]]; then
      match_found=true
      break
    fi
  done

  # Füge das Item zur entsprechenden Datei hinzu
  if [ "$match_found" = true ]; then
    jq --argjson item "$item" '.items += [$item]' "$output_with_arbeit" > tmp.json && mv tmp.json "$output_with_arbeit"
  else
    jq --argjson item "$item" '.items += [$item]' "$output_without_arbeit" > tmp.json && mv tmp.json "$output_without_arbeit"
  fi
done

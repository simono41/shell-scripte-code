#!/bin/bash

# Pfad zum Passwortspeicher
PASSWORD_STORE_DIR="${HOME}/.password-store"

# CSV-Datei für den Export
OUTPUT_FILE="vaultwarden_export.csv"

# CSV-Header hinzufügen
echo "folder,favorite,type,name,notes,fields,login_uri,login_username,login_password,login_totp" > "$OUTPUT_FILE"

# Funktion zum Konvertieren eines Passworts
convert_pass() {
    name=$1
    mapfile -t lines < <(pass show "$name")
    url=$(basename "$name")
    username=$(echo "${lines[1]}" | sed 's/^.*: //')
    password=${lines[0]}
    folder=$(dirname "$name")
    notes=$(printf "%s\n" "${lines[@]:2}")
    echo "$folder,,login,$url,$notes,,$url,$username,$password," >> "$OUTPUT_FILE"
}

# Alle Passwortdateien finden und konvertieren
find "$PASSWORD_STORE_DIR" -type f -name "*.gpg" | while read -r file; do
    pass_name=$(echo "$file" | sed "s|^$PASSWORD_STORE_DIR/||" | sed 's/\.gpg$//')
    convert_pass "$pass_name"
done

echo "Export abgeschlossen. Die CSV-Datei wurde in $OUTPUT_FILE gespeichert."

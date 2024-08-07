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
    username=$(basename "$name")  # Benutzername ist der Dateiname
    password=${lines[0]}
    folder=$(dirname "$name")
    notes=""
    totp=""

    # Notizen und TOTP überprüfen
    for line in "${lines[@]:1}"; do
        if [[ $line == otpauth* ]]; then
            totp=$line
        else
            notes+="$line\n"
        fi
    done

    # CSV-Zeile hinzufügen
    echo "$folder,,login,$url,$notes,,$folder,$username,$password,$totp" >> "$OUTPUT_FILE"
}

# Alle Passwortdateien finden und konvertieren
find "$PASSWORD_STORE_DIR" -type f -name "*.gpg" | while read -r file; do
    pass_name=$(echo "$file" | sed "s|^$PASSWORD_STORE_DIR/||" | sed 's/\.gpg$//')
    convert_pass "$pass_name"
done

echo "Export abgeschlossen. Die CSV-Datei wurde in $OUTPUT_FILE gespeichert."

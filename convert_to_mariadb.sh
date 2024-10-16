#!/bin/bash

input_file="ihatemoney.sql"
output_file="ihatemoney_mariadb.sql"

# Temporäre Datei erstellen
temp_file=$(mktemp)

# Konvertierung durchführen
sed '
    1i SET FOREIGN_KEY_CHECKS=0;
    $a SET FOREIGN_KEY_CHECKS=1;
    s/AUTOINCREMENT/AUTO_INCREMENT/g
    s/INTEGER PRIMARY KEY/INT AUTO_INCREMENT PRIMARY KEY/g
    s/INTEGER/INT/g
    s/FLOAT/DOUBLE/g
    s/BOOLEAN/TINYINT(1)/g
    s/TEXT/LONGTEXT/g
    s/VARCHAR(/VARCHAR(/g
    s/DATETIME/TIMESTAMP/g
    s/CREATE TABLE/CREATE TABLE IF NOT EXISTS/g
    s/"transaction"/`transaction`/g
    s/);/) ENGINE=InnoDB;/g
    /PRAGMA/d
    /BEGIN TRANSACTION/d
    /COMMIT/d
    s/INSERT INTO/INSERT IGNORE INTO/g
    s/'\''t'\''/1/g
    s/'\''f'\''/0/g
    s/datetime(/FROM_UNIXTIME(/g
' "$input_file" > "$temp_file"

# Ersetze die Originaldatei durch die konvertierte Version
mv "$temp_file" "$output_file"

echo "Konvertierung abgeschlossen. Die konvertierte SQL-Datei wurde als $output_file gespeichert."

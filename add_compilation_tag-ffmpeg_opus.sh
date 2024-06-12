#!/bin/bash

set -ex

# see
# https://superuser.com/questions/1708793/add-art-cover-in-ogg-audio-file
# https://xiph.org/flac/format.html#metadata_block_picture
# https://github.com/navidrome/navidrome/issues/2445

# Funktion, um Opus-Dateien zu verarbeiten
process_opus_files() {
    for file in "$1"/*.opus; do
        if [[ -f "$file" ]]; then
            # Extrahiere Cover
            ffmpeg -i "$file" -an -vcodec mjpeg -vf scale=320:-1 cover.jpg

# Berechne die Länge der Bilddaten in Bytes
IMAGE_LENGTH=$(wc -c < cover.jpg)

# Konvertiere die Länge in Hexadezimalwert und dann in Big-Endian-Format
IMAGE_LENGTH_HEX=$(printf '%08X' $IMAGE_LENGTH)
IMAGE_LENGTH_BE=$(echo $IMAGE_LENGTH_HEX | sed 's/\(..\)/\\x\1/g')

# Erstelle die vorbis.head Datei mit dem angegebenen Inhalt
# Beachte: Die Länge der Bilddaten wird hier eingefügt
echo -en "\0\0\0\x03\0\0\0\x0aimage/jpeg\0\0\0\x08test.jpg\0\0\0\x08\0\0\0\x0e\0\0\0\x20\0\0\0\0$IMAGE_LENGTH_BE" > vorbis.head


            # Erstelle eine base64-kodierte Version des Cover-Bildes und vorbis.head
            base64_cover=$(cat vorbis.head cover.jpg | base64 --wrap=0)

            # Verwende ffmpeg, um das METADATA_BLOCK_PICTURE-Tag zur Opus-Datei hinzuzufügen
            ffmpeg -hide_banner -i "$file" -metadata:s:a:0 "COMPILATION=1" -acodec copy -map 0:a -metadata:s:a METADATA_BLOCK_PICTURE="$base64_cover" "${file%.opus}_new.opus"

            # Entferne Cover
            rm cover.jpg

            # Optional: Ersetze die Originaldatei durch die neue
            mv "${file%.opus}_new.opus" "$file"
        fi
    done
}

# Exportiere die Funktion für die Verwendung mit find
export -f process_opus_files

# Verwende find, um die Funktion auf alle Opus-Dateien in allen Unterverzeichnissen auszuführen
find . -type d -exec bash -c 'process_opus_files "$0"' {} \;

# Bereinige die vorbis.head Datei
rm vorbis.head

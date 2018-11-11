#!/bin/bash

set -ex

#$(( (23-2)*2/3 ))
#cuts=$(( $1-1 ))
cuts="$1"
shift
name=0

# wenn 108 daten und 5 cute = 21 files je ein cut
# wenn 100 daten und 3 cuts = 33 files je ein cut
files="$(expr $# / $cuts)"
create=0
i=0

while (( "$#" ))
do

    #cutter
    if [ "$create" == "$i" ]; then
        create="$(expr $create + $files)"
        name="$(expr $name + 1)"
        echo ${name}
    fi
    i="$(expr $i + 1)"

    echo "${1%/*}"
    cd "${1%/*}" # gehe ins Verzeichnis

    FILENAME=${1##*/} # Dateiname ist alles ab dem letzten '/'
    echo "$FILENAME"
    # guck dir die Ausgabe erstmal an - wenn alles passt kannst Du das "echo" weglassen
    #ffmpeg -i "$FILENAME" -vn -n -c:a copy "${FILENAME%.*}1.mp3"
    cat "${FILENAME%.*}.mp3" >> onefile"$name".mp3
    shift
    cd -
done

#cd -
#pwd
#ffmpeg -i onefile.mp3 -acodec copy onefile-final.mp3
#rm onefile.mp3

#./convert_onefile_mp3_copy_cut.sh 3 PFAD/*

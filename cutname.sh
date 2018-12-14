#!/bin/bash

set -x

while (( "$#" ))
do

    cd "${1%/*}" # gehe ins Verzeichnis

    FILENAME=${1##*/} # Dateiname ist alles ab dem letzten '/'
    echo "$FILENAME"

    if ! [ -d ${FILENAME%%-*} ]; then

        mv ${FILENAME} ${FILENAME%%-*}
    else

        number=1
        while [ -d ${FILENAME%%-*}${number} ]
        do
            number=`expr ${number} + 1`
        done
        mv ${FILENAME} ${FILENAME%%-*}${number}
    fi

    cd -
    shift
done

#./cutname.sh <Ordner>/*-*

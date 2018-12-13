#!/bin/bash

set -x

while (( "$#" ))
do

    FILENAME=${1%%-*}

    mv ${1} ${FILENAME}

    shift
    cd -
done

#./cutname.sh <Ordner>/*-*

#!/bin/bash

set -x

while (( "$#" ))
do

    mv ${1} ${1%%-*}

    shift
done

#./cutname.sh <Ordner>/*-*

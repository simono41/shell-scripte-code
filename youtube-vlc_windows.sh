#!/usr/bin/env bash

set -ex

if [ "$1" == "--help" ] || [[ -z "$1" ]]
then
    echo "bitte alles kleinschreiben"
    echo "bash ./youtube-dl.sh suche/NOSUCHE URL/SUCHE FORMAT"
    echo "Formate: [opus/m4a/video/hd/fullhd/fullhdmp4/4k/FORMAT]"
    exit 0
fi

if [ "$1" == "suche" ] || [ "$1" == "nosuche" ]; then
    suche="$1"
    url="$2"
    format="$3"
else
    url="$1"
    format="$2"
fi

if [ "$format" == "opus" ]
then
    format="-f 251"
elif [ "$format" == "m4a" ]
then
    format="-f 140"
elif [ "$format" == "video" ]
then
    format="-f 43"
elif [ "$format" == "hd" ]
then
    format="-f 247+251"
elif [ "$format" == "fullhd" ]
then
    format="-f 303+251"
elif [ "$format" == "fullhdmp4" ]
then
format="-f 299+140" ]
elif [ "$format" == "4k" ]
then
    format="-f 315+251"
elif [ -n "$format" ]; then
    format="-f $format"
fi

video=""
if [ "$suche" == "suche" ]
then
    if ! youtube-dl "ytsearch:$url" -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames --no-playlist $format; then
        echo "Download fehlgeschlagen"
    fi
    video=$(youtube-dl "ytsearch:$url" -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames --no-playlist --get-filename $format)
else
    if ! youtube-dl -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames --no-playlist $format $url; then
        echo "Download fehlgeschlagen"
    fi
    video=$(youtube-dl -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames --no-playlist --get-filename $format $url)
fi

if [ "${video}" != "" ]; then
    vlc.exe ${video}
else
    echo "Konnte Video nicht finden"
fi

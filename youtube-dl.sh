#!/usr/bin/env bash

set -ex

if [ "$1" == "--help" ] || [[ -z "$1" ]]
then
    echo "bash ./youtube-dl.sh URL FORMAT"
    echo "Formate: [opus/m4a/video/hd/fullhd/4k]"
    exit 0
fi

url="$1"
format="$2"

if [ "$format" == "opus" ]
then
    format="-f 251 -x --audio-quality 0 --audio-format opus"
elif [ "$format" == "m4a" ]
then
    format="-f 140 -x --audio-quality 0 --audio-format m4a"
elif [ "$format" == "mp4" ]
then
    format="-f 140 -x --audio-quality 0 --audio-format mp4"
elif [ "$format" == "video" ]
then
    format="-f 43"
elif [ "$format" == "hd" ]
then
    format="-f 247+251"
elif [ "$format" == "fullhd" ]
then
    format="-f 303+251"
elif [ "$format" == "4k" ]
then
    format="-f 315+251"
fi

youtube-dl -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames $format $url

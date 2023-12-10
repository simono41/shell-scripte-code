#!/usr/bin/env bash

set -ex

if [ "$1" == "--help" ]
then
    echo "bash ./youtube-dl.sh URL FORMAT"
    echo "Formate: [opus/m4a/video/hd/fullhd/4k]"
    echo "Extra: (Zusätzliche Parameter)"
    exit 0
fi

url="$1"
format="$2"
extra="$3"

[[ -z "${url}" ]] && read -p "URL: " url
[[ -z "${format}" ]] && read -p "Format [opus/flac/m4a/mp4/video/hd/fullhd/4k]: " format
echo "Wenn man für alle Playlisten Unterordner anlegen will: [-o %(playlist_title)s/%(title)s.%(ext)s] (Praktisch für Downloads ganzer Kanäle"
[[ -z "${extra}" ]] && read -p "Sind noch zusätzliche Parameter gewünscht?: " extra

if [ "$format" == "opus" ]
then
    # https://github.com/yt-dlp/yt-dlp/issues/979
    format="--audio-format opus -f "ba" --format-sort "abr,codec""
    audio="-x"
    quality="--audio-quality 0"
elif [ "$format" == "flac" ]
then
    format="--audio-format flac -f "ba" --format-sort "abr,codec""
    audio="-x"
    quality="--audio-quality 0"
elif [ "$format" == "m4a" ]
then
    format="--audio-format m4a"
    audio="-x"
elif [ "$format" == "mp4" ]
then
    format="--audio-format mp4"
    audio="-x"
elif [ "$format" == "video" ]
then
    # Download and merge the best video-only format and the best audio-only format,
    # or download the best combined format if video-only format is not available

    # Download the best video available with the largest resolution but no better than 480p,
    # or the best video with the smallest resolution if there is no video under 480p
    # Resolution is determined by using the smallest dimension.
    # So this works correctly for vertical videos as well
    format="-S "res:480" -f "bv+ba/b""
elif [ "$format" == "hd" ]
then
    format="-S "res:720" -f "bv+ba/b""
elif [ "$format" == "fullhd" ]
then
    format="-S "res:1080" -f "bv+ba/b""
elif [ "$format" == "4k" ]
then
    format="-S "res:2160" -f "bv+ba/b""
fi

yt-dlp -i -c --socket-timeout 10000 --force-ipv4 --restrict-filenames --embed-thumbnail --embed-metadata --match-filter "!was_live" ${format} ${audio} ${quality} -v ${url} ${extra}

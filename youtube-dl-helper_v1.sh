#!/bin/bash

EINGABE=$(zenity --list --title "Youtube-DLH" --text "Was willst du haben?" \
--column "Auswahl" --column "Typ" --radiolist TRUE "Video runterholen" FALSE "Nur Audio runterholen" \ 
--width=600 --height=400)





if [ "$EINGABE" == "Video runterholen" ]
then

LINK=$(zenity --entry --title "Link einfügen" --text "Gib den Link zum Video ein du Penner" --width=600)

youtube-dl $LINK | zenity --progress --title "Downloade" --text "Ich arbeite dran du Penner" --pulsate && exit 0

fi




if [ "$EINGABE" == "Nur Audio runterholen" ]
then

LINK=$(zenity --entry --title "Link einfügen" --text "Gib den Link zum Video ein du Penner" --width=600)

youtube-dl -x --audio-format mp3 $LINK | zenity --progress --title "Downloade" --text "Ich arbeite dran du Penner" --pulsate && exit 0

fi
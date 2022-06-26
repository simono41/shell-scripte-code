#!/bin/bash

DOWNDIR=$HOME/Downloads/Youtubes/
mkdir $DOWNDIR


if which zenity >/dev/null
then echo "Zenity ist ok"
else echo "Zenity fehlt ich kann so nich arbeiten, du Penner!" && xterm -e "sudo zypper in -l -y zenity"
fi

if which youtube-dl >/dev/null
then echo "Youtube-dl ist ok"
else echo "Youtube-dl fehlt ich kann so nich arbeiten, du Penner!" && xterm -e "sudo zypper in -l -y youtube-dl"
fi


EINGABE=$(zenity --list --title "Youtube-DLH" --text "Was willst du haben?" \
--column "Auswahl" --column "Typ" --radiolist TRUE "Video runterholen" FALSE "Nur Audio runterholen" --width=600 --height=400)




if [ "$EINGABE" == "Video runterholen" ]
then

LINKVID=$(zenity --entry --title "Link einfügen" --text "Gib den Link zum Video ein du Penner" --width=600)

youtube-dl -o "$DOWNDIR%(title)s.%(ext)s" $LINKVID | zenity --progress --title "Downloade" --text "Ich arbeite dran du Penner" --pulsate && exit 0

fi




if [ "$EINGABE" == "Nur Audio runterholen" ]
then

LINKAUD=$(zenity --entry --title "Link einfügen" --text "Gib den Link zum Video ein du Penner" --width=600)

youtube-dl -o "$DOWNDIR%(title)s.%(ext)s" -x --audio-format mp3 $LINKAUD | zenity --progress --title "Downloade" --text "Ich arbeite dran du Penner" --pulsate && exit 0

fi
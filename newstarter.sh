#!/usr/bin/env bash
numscreens=3
count=0
if [ -z $1 ] ; then
    ./X-Plane-x86_64 --monitor_bounds=0,0,1920,1080,1920,0,1920,1080,3840,0,1920,1080 &
    while [  $count -lt $numscreens ]; do
        sleep 1
        count=$( wmctrl -l | grep X-System | wc -l)
    done
fi
screencount=1
wmctrl -l | grep X-Syst |awk '{ print $1 }' | while read ; do
    wmctrl -i -r "$REPLY" -T "X-System_$screencount"
    let  screencount=screencount+1
done
wmctrl -r "X-System_1" -e 1,0,0,1920,1080
wmctrl -r "X-System_2" -e 1,1920,0,1920,1080
wmctrl -r "X-System_3" -e 1,3840,0,1920,1080

# ./newstarter fix

#!/bin/bash

# NAME          pantech 0.1
# AUTHOR        Brent Maranzano
# LICENSE       GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)
# DESCRIPTION   Converts mkv file to mp4 with format appropriate to Pantech phone
# DEPENDENCIES  avconv

FILES=(*)
VIDDIR=$(zenity --width 200 --height 100 --entry --title "PANTECH" --text="Pantech Video Directory:")

function convertPantech {
    for F in "${FILES[@]}"
    do
        BASENAME=`echo "$F" | awk -F "." '{print $1}'`
        OUTPUT=`echo "$VIDDIR/$BASENAME.mp4"`
        echo "$OUTPUT"
        avconv -i "$F" -vcodec mpeg4 -f mp4 -aspect 4:3 -s qvga -qscale 4 -r 25 -acodec aac -strict experimental -ab 160k -ac 2 "$OUTPUT"
    done
    }
    
convertPantech

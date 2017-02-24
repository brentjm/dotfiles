#!/bin/bash

#Script to use ImageMagick's import to capture screen at defined intervals.
#The script will save screen shots with sequential numbering and crop the
#image as specified.

#Usage:
#$timed_screen_capture

function capture() {
    COUNTER=1
    while true
    do
        import -window root -display :0.0 -screen $(printf screen_%03d.png $COUNTER)
        convert -crop 1680x1050+1366x768 $(printf screen_%03d.png $COUNTER) $(printf cropped_%03d.png $COUNTER)
        COUNTER=$((COUNTER + 1))
        sleep 1s
        echo $COUNTER
    done
}

capture

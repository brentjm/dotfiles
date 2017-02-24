#!/bin/bash

# NAME          gif2mp4 0.1
# AUTHOR        Glutanimate (c) 2013 (http://askubuntu.com/users/81372/glutanimate)
# LICENSE       GNU GPL v3 (http://www.gnu.org/licenses/gpl.html)
# DESCRIPTION   Converts GIF files of a specific framerate to MP4 video files.
# DEPENDENCIES  zenity,imagemagick,avconv

TMPDIR=$(mktemp -d)
FPS=$(zenity --width 200 --height 100 --entry --title "gif2mp4" --text="Output frame rate:")
VIDDIR=$(dirname $1)

if [ -z "$FPS" ]
  then
      exit
fi

notify-send -i video-x-generic.png "gif2mp4" "Converting $(basename "$1") ..."

convert "$1" $TMPDIR/frame%02d.png
InFPS=`ls $TMPDIR | grep frame | wc -l`
echo $InFPS
avconv -r $InFPS -i $TMPDIR/frame%02d.png -r $FPS -qscale 4 -filter:v "setpts=2.0*PTS,setpts=2.0*PTS,setpts=2.0*PTS" "$VIDDIR/$(basename "$1" .gif).mp4"

notify-send -i video-x-generic.png "gif2mp4" "$(basename "$1") converted"

rm -rf $TMPDIR

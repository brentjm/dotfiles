#!/bin/bash
fname=`echo "$1" | cut -c 3-`
artist=`echo "$fname" | awk --field-separator - '{print $1}'`
title=`echo "$fname" | awk --field-separator - '{print $2}' | awk --field-separator . '{print $1}' | cut -c 2-`
id3v2 --artist "$artist" --song "$title" "$fname"

#!/bin/bash

function read_file () {
    OLD_IFS=$IFS
    IFS=$'\n'
    local _PKGS=($(grep -v ^# "$1"))
    echo "${_PKGS[@]}"
    IFS=$OLD_IFS
}

function download_url () {
    local _URLS=( "$@" )
    for _URL in "${_URLS[@]}"
    do
        local _TITLE=`youtube-dl --get-title "$_URL"`
        _TITLE="$_TITLE.mp3"
        echo "$_TITLE"
        youtube-dl "$_URL" -q -o - | avconv -i - -codec:a libmp3lame -ab 160k -ac 2 "$_TITLE"
        #avconv -i - -codec copy "$_TITLE" 
        #avconv -i - -codec:v libx264 -f mp4 -s hd1080 -qscale 4 -qmax 10 -r 24 -acodec aac -strict experimental -ab 160k -ac 2 "$_TITLE"
        #avconv -i - -codec:a aac -strict experimental -ab 160k -ac 2 "$_TITLE"
    done
}

URLS=($(read_file $1))
download_url "${URLS[@]}"

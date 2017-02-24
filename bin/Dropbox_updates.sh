#!/bin/bash
#Update files from dropbox directory
#Created: Brent Maranzano
#Last Updated: December 30, 2014
#use:
#$sudo bash Dropbox_updates.sh
#Could place this at the rc directory to run at system startup

function rosetta () {
    # Backup progress file for Rosetta Stone
    # File is a PlayOnLinux file (.PlayOnLinux/wineprefix/RosettaStone/drive_c/users/Public/Application Data/Rosetta Stone/tracking.db3)

    for u in brent rebekah jakob julia logan
    do
        cp --preserve --update "/home/brent/Dropbox/$u/." "/home/$u/.PlayOnLinux/wineprefix/RosettaStone/drive_c/users/Public/Application Data/Rosetta Stone/tracking.db3"
    done
}

function rhythmbox () {
    # Backup Rhythmbox plyalists 
    # File is .local/share/rhythmbox/playlists.xml

    for u in brent rebekah jakob julia logan
    do
        cp --preserve --update "/home/brent/Dropbox/$u/." "/home/$u/.local/share/rhythmbox/playlists.xml"
    done
}

function brent () {
    # Backup brent directories

    # bin
    cp --preserve --update --recursive "/home/brent/Dropbox/brent/." "/home/brent/bin"

    # tex
    cp --preserve --update --recursive "/home/brent/Dropbox/brent/." "/home/brent/texmf"

    # vim
    cp --preserve --update "/home/brent/Dropbox/brent/." "/home/brent/.vimrc"
    cp --preserve --update --recursive "/home/brent/Dropbox/brent/." "/home/brent/.vim"

    # python_lib
    cp --preserve --update --recursive "/home/brent/Dropbox/brent/." "/home/brent/python_lib"
}

rosetta
rhythmbox
brent

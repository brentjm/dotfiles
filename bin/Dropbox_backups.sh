#!/bin/bash
#Backup files to dropbox directory
#Created: Brent Maranzano
#Last Updated: February 26, 2016

function rosetta () {
    # Backup progress file for Rosetta Stone
    # File is a PlayOnLinux file (.PlayOnLinux/wineprefix/RosettaStone/drive_c/users/Public/Application Data/Rosetta Stone/tracking.db3)

    for u in brent rebekah jakob julia logan
    do
        cp --preserve --update "/home/$u/.PlayOnLinux/wineprefix/RosettaStone/drive_c/users/Public/Application Data/Rosetta Stone/tracking.db3" "/home/brent/Dropbox/$u/."
    done
}

function rhythmbox () {
    # Backup Rhythmbox plyalists 
    # File is .local/share/rhythmbox/playlists.xml

    for u in brent rebekah jakob julia logan
    do
        cp --preserve --update "/home/$u/.local/share/rhythmbox/playlists.xml" "/home/brent/Dropbox/$u/."
    done
}

function brent () {
    # Backup brent directories

    # bashrc
    cp --preserve --update --recursive "/home/brent/.bashrc" "/home/brent/Dropbox/brent/."

    # bin
    cp --preserve --update --recursive "/home/brent/bin" "/home/brent/Dropbox/brent/."

    # tex
    cp --preserve --update --recursive "/home/brent/texmf" "/home/brent/Dropbox/brent/."

    # vim
    cp --preserve --update "/home/brent/.vimrc" "/home/brent/Dropbox/brent/."
    cp --preserve --update --recursive "/home/brent/.vim" "/home/brent/Dropbox/brent/."

    # python_lib
    cp --preserve --update --recursive "/home/brent/python_lib" "/home/brent/Dropbox/brent/."

    # eslint
    cp --preserve --update --recursive "/home/brent/.eslintrc" "/home/brent/Dropbox/brent/."
}

#rosetta
#rhythmbox
brent

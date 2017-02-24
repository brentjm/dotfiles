#!/bin/bash
# 
# Functions:
#     function make_user_folders - Makes folders for user data in user partition
#     function make_links - Makes links from users home directory to the user partition
# 
#
#useage:
#$sudo bash linux_setup_userfiles.sh 
#


function make_user_folders () {
    # Make folders for each user in the /home/userfiles partition
    # This is not needed if the /home/userfiles partition already has them from a previous install
    for u in 'brent' 'rebekah' 'jakob' 'julia' 'logan' 
    do
        mkdir /home/userfiles/$u
        for d in 'Desktop' 'Documents' 'Downloads' 'Music' 'Pictures' 'Public' 'Templates' 'Videos'
        do
            if [ -d "/home/$u/$d" ]
            then
                mv /home/$u/$d /home/userfiles/$u/.
            else
                mkdir /home/userfiles/$u/$d
            fi
        done
    done
}


function make_links () {
    # Create symbolic links from /home parition to /home/userfiles parition.
    # Function cannot work until all users have logged in to create home folders.
    for u in 'brent' 'rebekah' 'jakob' 'julia' 'logan' 
    do
        for d in 'Desktop' 'Documents' 'Downloads' 'Music' 'Pictures' 'Public' 'Templates' 'Videos'
        do
            rmdir /home/$u/$d
            ln -s -t /home/$u /home/userfiles/$u/$d
            chown --no-dereference $u:users /home/$u/$d
        done
    done
}


#make_user_folders
make_links

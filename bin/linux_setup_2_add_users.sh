#!/bin/bash

# Creates new user accounts
# Functions:
#    configure_groups - modify configuration so each user is in same group
#    add_users - add users

#useage:
#$sudo bash linux_setup_add_users.sh 

function configure_groups () {
# Configure the groups so each user uses the same group
# with group id 100.

    # change adduser.conf so each user is in groups users
    sed -i -e 's/USERGROUPS=no/USERGROUPS=yes/' /etc/adduser.conf

    # change brent group id to 100
    usermod --gid 100 brent

    # check that users group number is 100
    gid=`awk -F':' '/^users/ {print $3}' /etc/group`
    if [ "$gid" = "100" ]; then
        echo "users gid is 100"
    else
        echo "Script exited: users gid is $gid. Set users gid to 100 to proceed."
        exit
    fi
}

function add_users () {
    # add users 
    uid=1001 
    for u in "rebekah" "jakob" "julia" "logan"
    do
        echo "adduser --gid 100 --uid $uid $u"
        adduser --gid 100 --uid $uid $u
        passwd -e $u
        uid=$((uid+1))
    done
}

#configure_groups
add_users

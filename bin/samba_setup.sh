#!/usr/bin/bash

function configuration() {
    # Modify the /etc/samba/smb.conf file to make the home directories
    # browsable and writable.
    conf="/etc/samba/smb.conf"
    echo "${conf}"
    sudo sed -i -e "s/;\[homes\]/\[homes\]/" "${conf}"
    sudo sed -i -e "s/;   comment = Home Directories/   comment = Home Directories/" "${conf}"
    sudo sed -i -e "s/;   browseable = no/   browseable = yes/" "${conf}"
    sudo sed -i -e "s/;   read only = yes/   read only = no/" "${conf}"
    sudo sed -i -e "s/;   create mask = 0700/   create mask = 0700/" "${conf}"
    sudo sed -i -e "s/;   directory mask = 0700/   directory mask = 0700/" "${conf}"
    sudo sed -i -e "s/;   directory mask = 0700/   directory mask = 0700/" "${conf}"
    sudo sed -i -e "s/;   valid users = %S/   valid users = %S/" "${conf}"
}

function smbusers() {
    # Add users to the samba users
    echo 'brent="brent"' > /etc/samba/smbusers
}

function sambapassword() {
    # Prompt the user for a password
    sudo smbpasswd -a brent
}

function restartSamba() {
    # Restart the samba server
    sudo service smbd restart
    sudo service nmbd restart
}

function sambaCheck() {
    # Check if samba is running
    netstat -ltn | grep -q -E '139|445'
    check=$?
    echo $check
    if [ "$check" = 0 ]
    then
        echo "Samba started"
    else
        echo "Samba not started"
    fi
}

configuration
smbusers
sambapassword
restartSamba
sambaCheck

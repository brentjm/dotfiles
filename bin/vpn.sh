#!/bin/bash

#Backup files
#Created: Brent Maranzano
#Last Updated: December 21, 2016

# Usage:
# sudo ./vpn.sh

# Functions
#   VPN - start the Private Internet Access VPN

function vpn () {
  # Start the Private Internet Access VPN
  if [ "$#" -gt 0 ]; then
    LOC="${1}"
  else
    ls -al /etc/openvpn
    echo "Type in the VPN server and press [ENTER]"
    read server
    if [[ ! -z "$server" ]]
    then
        LOC="$server"
    else
        LOC="US East.ovpn"
    fi
  fi

  echo "sudo openvpn \"${LOC}\""
  (cd /etc/openvpn ; sudo openvpn "${LOC}")
}

vpn "$@"

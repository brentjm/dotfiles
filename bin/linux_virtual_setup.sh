#!/bin/bash
#
# Functions:
#    function install_ packages
#
#useage:
#$sudo bash linux_setup_1_partisions.sh 


function install_packages() {
    # Install minimum packages
    sudo apt-get install -y build-essential git vim curl wget cmake clang python-dev powerline
}

function guest_additions() {
    # Install guest additions into Virtual machine
    sudo apt-get install virtualbox-guest-additions-iso
    sudo mkdir -p /media/brent/VBox_GA
    sudo mount -o loop /usr/share/virtualbox/VBoxGuestAdditions.iso /media/brent/VBox_GA
    sudo /media/brent/VBox_GA/VBoxLinuxAdditions.run
}

function dotfiles() {
    git clone https://github.com/brentjm/dotfiles.git ~
}

install_packages
#guest_additions

#!/bin/bash
# Install packages that are either not in the default repositories or are 
# better to # install via another repository or from downloaded packages 
# or just don't install easily with the  overall installation script.

function linuxHeaders() {
    sudo apt-get install linux-headers-$(uname -r)
}

function libncurses() {
    libncurses=$(apt-cache search libncurses | awk '{print $1}' | grep libncurses[0-9]$)
    sudo apt-get install "$libncurses"
}

function googleChrome() {
    wget --directory-prefix=/home/brent/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /home/brent/Downloads/google-chrome-stable_current_amd64.deb
    sudo apt-get install -f
}

function virtualBox() {
    echo -n "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" > virtualbox.list
    sudo mv virtualbox.list /etc/apt/sources.list.d/.
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install virtualbox-5.1
}

function dvdcss () {
    # Install the dvd reading class 

    # Only neccessary for 12.04 to 15.04
    # sudo /usr/share/doc/libdvdread4/install-css.sh
    
    # For versions 15.1 and later
    # Run this after the libdvd-pkg is installed via apt
    sudo dpkg-reconfigure libdvd-pkg
}

function youtubeDL() {
    # Install youtube-dl from the downloads to maintain most
    # recent version.
    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
}

function blender() {
    # Install the latest version of Blender.
    wget --directory-prefix=/home/brent/Downloads/ http://download.blender.org/release/Blender2.78/blender-2.78c-linux-glibc219-x86_64.tar.bz2
    tar -xjf /home/brent/Downloads/blender*.tar.bz2
    sudo mv blender* /opt/blender
    sudo cp /opt/blender/blender.desktop /home/brent/.local/share/applications/.
    sudo chown -R root:root /opt/blender
    sudo cp /opt/blender/blender.desktop /usr/share/applications/.
     # This was an attempt to make the icon, but was unsuccessful.
     #mkdir -p /home/brent/.icons/hicolor/48x48
     #sudo ln -s /opt/blender/blender /usr/bin/blender
}

function vundles() {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/dotfiles/.vim/bundle/vundle 
}

function YouCompleteMe() {
    python ~/dotfiles/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer
}

function node() {
    # Adding the NodeSource APT repository for Debian-based 
    # distributions repository AND the PGP key for verifying packages
    #curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    #sudo apt-get install -y nodejs
    # Or use nvm. CHECK THE VERSION NUMBER!!!
    sudo apt-get install build-essential libssl-dev
    sudo -u brent curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | sudo -u brent bash
    source ~/.bashrc
    sudo -r brent npm install node
}

function anaconda() {
    wget --directory-prefix=/home/brent/Downloads/ https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
    md5sum ~/Downloads/Anaconda*.sh
    sha256sum ~/Downloads/Anaconda*.sh
    sudo -u brent bash ~/Downloads/Anaconda3-4.3.0-Linux-x86_64.sh 
}

function postgres() {
    sudo apt-get install -y postgresql 
    ver=$(psql --version | awk -F " " '{print $3}' | cut -c -3)
    sudo apt-get install -y libpq-dev postgresql-server-dev-${ver}
}

#linuxHeaders
#libncurses
#googleChrome
virtualBox
#dvdcss
#youtubeDL
#blender
#node
#vundles
#YouCompleteMe
#anaconda
#postgres

#!/bin/bash
# Install packages that are either not in the default repositories or are 
# better to # install via another repository or from downloaded packages 
# or just don't install easily with the  overall installation script.

function linuxHeaders() {
    sudo apt-get install linux-headers-$(uname -r)
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
    exit
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
     mkdir -p /home/brent/.icons/hicolor/48x48
     sudo ln -s /opt/blender/blender /usr/bin/blender
}

function vim() {
    ln -s /home/brent/dotfiles/.vimrc /home/brent/.vimrc
    ln -s /home/brent/dotfiles/.vim /home/brent/.vim
    git ~/dotfiles/.vim/ clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
     python ~/dotfiles/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer
}

function bashrc() {
    mv ~/.bashrc ~/.bashrc_old
    ln -s ~/dotfiles/.bashrc ~/.bashrc
}

function node() {
    # Adding the NodeSource APT repository for Debian-based 
    # distributions repository AND the PGP key for verifying packages
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

function anaconda() {
    wget --directory-prefix=/home/brent/Downloads/ https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
    md5sum ~/Downloads/Anaconda*.sh
    sha256sum ~/Downloads/Anaconda*.sh
    bash ~/Downloads/Anaconda3-4.3.0-Linux-x86_64.sh 
}

function postgres() {
    sudo apt-get install -y postgresql 
    ver=$(psql --version | awk -F " " '{print $3}' | cut -c -3)
    sudo apt-get install -y libpq-dev postgresql-server-dev-${ver}
}

#linuxHeaders
#googleChrome
#virtualBox
#dvdcss
#youtubeDL
#blender
#vim
#bashrc
#node
#anaconda
postgres

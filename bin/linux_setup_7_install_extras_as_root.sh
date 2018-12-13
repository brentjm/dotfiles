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

function install_ctags() {
    pwd=${PWD}
    mkdir ~/Downloads/ctags
    git clone https://github.com/universal-ctags/ctags ~/Downloads/ctags
    cd ~/Downloads/ctags
    sudo apt install -y pkg-config
    ./autogen.sh
    # installation directory; defaults to /usr/local
    ./configure --prefix=/usr/local 
    make
    sudo make install # may require extra privileges depending on where to install
    cd $pwd

function virtualBox() {
    # Install virtualbox as the most corrent version
    # Note that this scipt requires some modifications to work properly for versions.

    # Make sure to update the ubuntu version.
    #read codename
    codename=$(lsb_release -c | awk '{print $2}')
    if [ ! -f "/etc/apt/sources.list.d/virtualbox.list" ]; then
        echo -n "deb http://download.virtualbox.org/virtualbox/debian $codename contrib" > virtualbox.list
        sudo mv virtualbox.list /etc/apt/sources.list.d/.
    fi
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    # Make sure to update the version.
    echo "Virtualbox version (e.g. 5.2)?"
    read "version"
    #sudo apt-get install virtualbox-5.2
    sudo apt-get install virtualbox-"$version"
}

function dvdcss () {
    # Install the dvd reading class 

    # Only neccessary for 12.04 to 15.04
    # sudo /usr/share/doc/libdvdread4/install-css.sh
    
    # For versions 15.1 and later
    # Run this after the libdvd-pkg is installed via apt
    libdvd-pkg
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
    echo "Blender version (e.g. 2.78)?"
    read "version"
    wget --directory-prefix=/home/brent/Downloads/ http://download.blender.org/release/Blender"$version"/blender-"$version"c-linux-glibc219-x86_64.tar.bz2
    tar -xjf /home/brent/Downloads/blender*.tar.bz2
    sudo mv blender* /opt/blender
    sudo cp /opt/blender/blender.desktop /home/brent/.local/share/applications/.
    sudo chown -R root:root /opt/blender
    sudo cp /opt/blender/blender.desktop /usr/share/applications/.
     # This was an attempt to make the icon, but was unsuccessful.
     #mkdir -p /home/brent/.icons/hicolor/48x48
     #sudo ln -s /opt/blender/blender /usr/bin/blender
}

function postgres() {
    sudo apt-get install -y postgresql 
    ver=$(psql --version | awk -F " " '{print $3}' | cut -c -3)
    sudo apt-get install -y libpq-dev postgresql-server-dev-${ver}
}

function install_docker() {
    sudo -u brent curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce
    sudo usermod -aG docker brent
}

#linuxHeaders
#libncurses
#googleChrome
virtualBox
#dvdcss
#youtubeDL
#blender
#postgres
#install_docker

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

function install_googleChrome() {
    wget --directory-prefix=/home/brent/Downloads/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /home/brent/Downloads/google-chrome-stable_current_amd64.deb
    sudo apt-get install -f
}

function install_ctags() {
    pwd=${PWD}
    mkdir ~/Downloads/ctags
    git clone https://github.com/universal-ctags/ctags ~/Downloads/ctags
    sudo chown -R brent:brent ~/Downloads/ctags
    cd ~/Downloads/ctags
    sudo apt install -y dh-autoreconf pkg-config
    ./autogen.sh
    # installation directory; defaults to /usr/local
    ./configure --prefix=/usr/local 
    make
    sudo make install # may require extra privileges depending on where to install
    cd $pwd
}

function install_virtualBox() {
    # Install virtualbox as the most corrent version
    # Note that this scipt requires some modifications to work properly for versions.

    codename=$(lsb_release -c | awk '{print $2}')
    if [ ! -f "/etc/apt/sources.list.d/virtualbox.list" ]; then
        echo -n "deb http://download.virtualbox.org/virtualbox/debian $codename contrib" > virtualbox.list
        sudo mv virtualbox.list /etc/apt/sources.list.d/.
    fi
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    # Make sure to update the version.
    echo "Virtualbox version (e.g. #.#)?"
    read "version"
    sudo apt-get install virtualbox-"$version"
}

function install_dvdcss () {
    # Install the dvd reading class 

    # Only neccessary for 12.04 to 15.04
    # sudo /usr/share/doc/libdvdread4/install-css.sh
    
    # For versions 15.1 and later
    # Run this after the libdvd-pkg is installed via apt
    libdvd-pkg
    sudo dpkg-reconfigure libdvd-pkg
}

function install_youtubeDL() {
    # Install youtube-dl from the downloads to maintain most
    # recent version.
    sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
}

function install_blender() {
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

function install_postgres() {
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

function install_neovim() {
    cd ~/Downloads
    wget --quiet https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage --output-document ~/Downloads/nvim
    sudo chown root:root nvim
    sudo chmod +x nvim
    sudo mv nvim /usr/bin/.
    sudo -u brent mkdir -p ~/.config/nvim
    cd ~/.config/nvim 
    sudo -u brent ln -s ~/dotfiles/init.vim
    sudo -u brent curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    sudo apt install python3-pip
    sudo -u brent pip3 install --user pynvim
}

#linuxHeaders
#libncurses
install_ctags
#install_googleChrome
#install_virtualBox
#install_dvdcss
#install_youtubeDL
#install_blender
#install_postgres
#install_docker
#install_neovim

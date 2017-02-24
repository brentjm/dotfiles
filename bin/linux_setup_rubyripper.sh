#!/bin/bash
# script to setup rubyripper

function installation () {
    # install ruby ripper
    cd ~/Downloads
    RUBYTAR=`ls | grep ruby`
    tar -xjf ~/Downloads/"$RUBYTAR"
    RUBYDIR=`ls -al | grep ruby | grep ^d`
    cd "$RUBYDIR"
    ./configure --enable-lang-all --enable-gtk2 --enable-cli
    sudo make install
}

function settings () {
    # create the rubyripper configuration file
    SETTINGS="
    flac=false\n
    flacsettings=--best -V\n
    vorbis=false\n
    vorbissettings=-q 4\n
    mp3=true\n
    mp3settings=-V 3 --id3v2-only\n
    wav=false\n
    other=false\n
    othersettings=\n
    playlist=false\n
    cdrom=/dev/sr0\n
    offset=0\n
    maxThreads=2\n
    rippersettings=\n
    max_tries=5\n
    basedir=~/Music\n
    naming_normal=%a/%b/%a - %t\n
    naming_various=%va/%b/%a - %t\n
    naming_image=%f/%a (%y) %b/%a - %b (%y)\n
    verbose=false\n
    debug=true\n
    eject=true\n
    ripHiddenAudio=true\n
    minLengthHiddenTrack=2\n
    req_matches_errors=2\n
    req_matches_all=2\n
    site=http://freedb.freedb.org/~cddb/cddb.cgi\n
    username=anonymous\n
    hostname=my_secret.com\n
    first_hit=true\n
    freedb=true\n
    editor=gedit\n
    filemanager=nautilus --no-desktop\n
    browser=firefox\n
    no_log=false\n
    create_cue=false\n
    image=false\n
    normalize=false\n
    gain=album\n
    gainTagsOnly=false\n
    noSpaces=false\n
    noCapitals=false\n
    pregaps=prepend\n
    preEmphasis=cue\n
    freedbCache=/home/brent/.cache/rubyripper/freedb.yaml"

    for u in "brent" "rebekah" "jakob" "julia" "logan"
    do
        sudo rm -fr "/home/$u/.config/rubyripper"
        sudo mkdir "/home/$u/.config/rubyripper"
        sudo echo -e "$SETTINGS" | sudo sed -e 's/^ //' | sudo tee "/home/$u/.config/rubyripper/settings" > /dev/null
        sudo chown -R "$u":users "/home/$u/.config/rubyripper"
    done
}

function desktop () {
    # add desktop application information for subsequent unity launcher
    RRIP_DESKTOP="[Desktop Entry]
    Type=Application
    Name=Rubyripper
    GenericName=Secure Audio Disc Ripper
    GenericName[nl]=Veilige Audio CD Ripper
    Icon=rubyripper
    Exec=rrip_gui
    Categories=Audio;AudioVideo;"

    sudo echo "$RRIP_DESKTOP" > /usr/local/share/applications/rubyripper.desktop
}

installation
settings
desktop



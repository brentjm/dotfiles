#!/bin/bash
# Install packages that are either not in the default repositories or are 
# better to # install via another repository or from downloaded packages 
# or just don't install easily with the  overall installation script.

function node() {
    echo "nvm version number (e.g. v0.33.1)?"
    read version
    #curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
    curl -o- https://raw.githubusercontent.com/creationix/nvm/"$version"/install.sh | bash
    source ~/.bashrc
    nvm install node
    echo "May have to run nvm install node as .bashrc file cannot be sourced"
}

function vundles() {
    git clone https://github.com/VundleVim/Vundle.vim.git /home/brent/dotfiles/.vim/bundle/vundle 
    vim +PluginInstall +qall
    #echo "Must run :PluginsInstall in vim"
}

function YouCompleteMe() {
    #python ~/dotfiles/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer
    python ~/dotfiles/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer --system-libclang
}

function ternforvim() {
    # https://github.com/majutsushi/tagbar/wiki
    cd ~/dotfiles/.vim/bundle/tern_for_vim
    npm install
    # Can check if it's working by running
    # $/home/brent/dotfiles/.vim/bundle/tern_for_vim/node_modules/.bin/tern
}

function anaconda() {
    # Installs the anaconda distributions
    # Note that the version has to be changed!
    echo "Python version?"
    read pythonversion
    echo "Anaconda distribution version (e.g. 5.0.1)?"
    read condaversion
    #wget --directory-prefix=/home/brent/Downloads/ https://repo.continuum.io/archive/Anaconda3-4.3.0-Linux-x86_64.sh
    wget --directory-prefix=/home/brent/Downloads/ https://repo.continuum.io/archive/Anaconda"$pythonversion"-"$condaversion"-Linux-x86_64.sh
    md5sum ~/Downloads/Anaconda*.sh
    sha256sum ~/Downloads/Anaconda*.sh
    bash ~/Downloads/Anaconda"$pythonversion"-"$condaversion"-Linux-x86_64.sh 
}

function netrc_file() {
    # Create the .netrc file
    echo "machine github.com" > ~/.netrc_trial
    sed -i -e "/^/{
    a\login brentjm
    a\password my_password
    a\ 
    a\machine api.github.com
    a\login brentjm
    a\password my_password
    }" ~/.netrc_trial
}

function git_config() {
    cat > ~/.gitconfig <<EOF
[user]
    email = brent_maranzano@yahoo.com
    name = brentjm
EOF
}

function powerline() {
  cat >> ~/.bashrc <<EOF
  if [ -f \`which powerline-daemon\` ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bindings/bash/powerline.sh
  fi
EOF
}



#node
#vundles
#YouCompleteMe
#ternforvim
#anaconda
#netrc_file
git_config
#powerline
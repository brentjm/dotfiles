#!/bin/bash
# 
# Makes links for for commont dot-configuration-files to the dotfiles directory
#
# Usage:
# $./linux_setup_symboliclinks.sh

function make_links() {
    cd ~
    for element in .bashrc .bash_aliases .vimrc .inputrc .gvimrc .vim .tern-config .eslintrc.json bin
    do
        [ -e "$element" ] && mv "$element" "$element_old"
        ln -s dotfiles/"$element"
    done
}

make_links

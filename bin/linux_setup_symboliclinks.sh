#!/bin/bash

function make_links() {
    cd ~
    for element in .bashrc .vimrc .inputrc .gvimrc .vim bin
    do
        [ -e "$element" ] && mv "$element" "$element_old"
        ln -s dotfiles/"$element"
    done
}

make_links

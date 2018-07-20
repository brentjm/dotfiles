#!/bin/bash

function set_terminal_title() {
    echo -ne "\033]0;${1}\007"
}

alias set_title=set_terminal_title

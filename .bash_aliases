#!/bin/bash

function set_terminal_title() {
    echo -ne "\033]0;${1}\007"
}

function use_conda_python() {
    # added by Anaconda3 4.3.0 installer
    export OLD_PATH="$PATH"
    export PATH="/home/brent/miniconda3/bin:$PATH"
}

function stop_using_conda_python() {
    # added by Anaconda3 4.3.0 installer
    export PATH="$OLD_PATH"
}

alias set_title=set_terminal_title
alias activate_conda=use_conda_python
alias deactivate_conda=stop_using_conda_python

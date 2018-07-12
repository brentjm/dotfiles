#!/bin/bash 

# Install packages listed in a text file

# Functions:
#    read_file - reads the package names from a text file
#    search_dpkg - searches dpkg to see if packages are already installed
#    search_apt - searches apt package manager for packages
#    apt_install - install packages with apt

#useage:
#$sudo bash linux_setup_5_package_installation.sh linux_setup_5_package_installation.txt


function read_file () {
    # Reads a text file that has package names in it.

    # Arguments:
    #   package_file (string) - file with package names

    # Returns array of package names

    OLD_IFS=$IFS
    IFS=$'\n'

    local _PKGS=($(grep -v ^# "$1"))

    echo "${_PKGS[@]}"
    IFS=$OLD_IFS
}


function search_dpkg () {
    # Searches dpkg for packages that are already installed

    # Arguments
    #    packages (array) - array of sting package names

    # Returns array of strings of package names that were not found in dpkg

    local _DPKGS=( "$@" )
    for _DPKG in "${_DPKGS[@]}"
    do
        _RESULTS=`dpkg -l | grep "$_DPKG" | awk '{print $2}' | grep -E -e "^$_DPKG$"`
        if [[ $_RESULTS != $_DPKG ]]
        then
            _NOTINSTALLED+=("$_DPKG")
        fi
    done
    echo "${_NOTINSTALLED[@]}"
}


function search_apt () {
    # Search apt for packages

    # Arguments:
    #    packages (array) - packages to search apt

    # Returns array of package names that were found by apt
    local _APKGS=( "$@" )
    for _NAME in "${_APKGS[@]}" 
    do
        # Do an apt name search
        local _APKG=`apt-cache search --names-only "^$_NAME$" | cut -d' ' -f1`
        local _CNT=`echo $_APKG | awk -F " " '{ print NF }'`

        # If multiple packages are returned, try grep
        if [ $_CNT -gt 1 ]
        then
            local _APKG=`apt-cache search --names-only "$_NAME" | grep -E -e "^$_NAME " | cut -d' ' -f1`
        fi
        
        # If there is exactly one package, add it to the valid array.
        if [ $_CNT -eq 1 ]
        then
            _VALID+=("$_APKG")
        fi
    done
      
    echo "${_VALID[@]}"
}

function apt_install () {
    # Install packages

    # Arguments:
    # packages (array) - names of packages to install

    # returns nothing

    local _PKGS=( "$@" )
    apt-get install "${_PKGS[@]}"
#    echo "${_PKGS[@]}"
#    for _PKG in "${_PKGS[@]}" 
#    do
#       echo "apt-get install --assume-yes $_PKG"
#       apt-get install --assume-yes "$PKG"
#    done
}

PKGS=($(read_file $1))
echo -e "\nThe following ${#PKGS} packages were requested: \n ${PKGS[@]} \n\n"

NOTINSTALLED=($(search_dpkg "${PKGS[@]}"))
echo -e "The following ${#NOTINSTALLED} were not found in dpkg: \n ${NOTINSTALLED[@]} \n\n"

FOUND=($(search_apt "${NOTINSTALLED[@]}"))
echo -e "The following ${#FOUND} packages will try to be installed with apt: \n ${FOUND[@]}"

apt_install "${FOUND[@]}"

#!/bin/bash

function packages {
    if [[ "$(which yay)" != "/usr/bin/yay" ]]; then
        cd
        git clone https://aur.archlinux.org/yay.git
        cd yay
        yes | makepkg -si
        cd
        rm -rf yay
    fi
    yay -Syu $@
}

function ask {
    exec 3>&1;
    result=$(dialog --title "TOS Installer" --inputbox "$1" 0 0 "$2" 2>&1 1>&3);
    exec 3>&-;
}

function prmpt {
    dialog --title "TOS Installer" --yesno "$1" 0 0
}

# usage download <directory> <filename> <url>
function download {
    mkdir -p "$1"
    curl "$3" -o "$1"/"$2"
}

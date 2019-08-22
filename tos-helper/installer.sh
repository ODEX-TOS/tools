#!/bin/bash

source tos-helper/color.sh


function installtosdialog {
    printf "${RED}Installing arch via a dialog${NC}\n"
    if [[ ! -f dialogarchinstall ]]; then
        curl https://raw.githubusercontent.com/F0xedb/helper-scripts/master/tosinstall -o tosinstall
        chmod +x tosinstall
    fi
    ./tosinstall 
}
case "$1" in
    "-iso")
        if [ "$(id -u)" == "0" ]; then
            installtosdialog
        else
            printf "${RED} Only root user can install TOS${NC}\n"
        fi 
    ;;
esac

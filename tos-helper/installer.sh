#!/bin/bash

source tos-helper/color.sh


function installarchdialog {
    printf "${RED}Installing arch via a dialog${NC}\n"
    if [[ ! -f dialogarchinstall ]]; then
        curl https://raw.githubusercontent.com/F0xedb/helper-scripts/master/dialogarchinstall -o dialogarchinstall
        chmod +x dialogarchinstall
    fi
    ./dialogarchinstall 
}
case "$1" in
    "-iso")
        if [ "$(id -u)" == "0" ]; then
            installarchdialog
        else
            printf "${RED} Only root user can install TOS${NC}\n"
        fi 
    ;;
esac

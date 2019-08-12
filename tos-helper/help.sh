#!/bin/bash
function help {
        printf "${ORANGE} $name ${NC}OPTIONS: bluetooth|network|screen|theme|volume -c -h -rs -u -Q -R- -S -iso\n\n" "${ORANGE}" "$name" "${NC}"
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name bluetooth \t\t\t Control all bluetooth settings \n"
        printf "$name network \t\t\t Control all network related settings\n"
        printf "$name screen \t\t\t Control all screen related settings\n"
        printf "$name theme \t\t\t Control all theme related settings\n"
        printf "$name volume \t\t\t Controll the volume\n"
        printf "$name -c | --cypto \t\t generate a crypto key \n"
        printf "$name -c | --cypto <user@ip> \t copy over your ssh key to a remote computer \n"
        printf "$name -h | --help \t\t Show this help message \n"
        printf "$name -rs | --repair-system \t Perform a basic system repair attempt \n"
        printf "$name -u | --update \t\t Update your system  \n"
        printf "$name -Q \t\t\t\t Query the local database of packages  \n"
        printf "$name -R \t\t\t\t Remove software from the system  \n"
        printf "$name -S \t\t\t\t Search the online database  \n"

}


case "$1" in
    ""|"-h"|"--help")
    help
    ;;
esac

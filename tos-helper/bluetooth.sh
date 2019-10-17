#!/bin/bash

function help {
        printf "${ORANGE} $name bluetooth ${NC}OPTIONS: set | list | connect | disconnect | pair | full | help\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name bluetooth help \t\t\t\t Show this help message\n"
        printf "$name bluetooth set <on|off> \t\t\t Enable or disable bluetooth\n"
        printf "$name bluetooth list <scan> \t\t\t Show all bluetooth devices found. if scan is entered go into a scan mode\n"
        printf "$name bluetooth connect <device> \t\t\t Connect to a bluetooth device based on its mac\n"
        printf "$name bluetooth disconnect <device> \t\t Disconnect from said device\n"
        printf "$name bluetooth pair <device>\t\t\t Pair with a bluetooth device\n"
        printf "$name bluetooth full\t\t\t\t Go into an interactive shell\n"
}

case "$2" in
   "s"|"set")
            bluetoothctl power "$3"
            if [[ ! -f "$themefile" ]]; then
                mkdir -p "$HOME/.config/tos"
                touch "$themefile"
                printf "off\ntime=1000\nbluetooth=false\n" >>"$themefile"
            fi
            sed -i 's/^bluetooth=false$/'"bluetooth=$1"'/' "$themefile"
            sed -i 's/^bluetooth=true$/'"bluetooth=$1"'/' "$themefile"
    ;;
   "l"|"list")
            if [[ $3 == "scan" ]]; then
                    bluetoothctl scan on &
                    printf "${RED}Press enter if you want to stop scanning${NC}\n"
                    read -r 
                    kill %%
            fi
            bluetooth
            bluetoothctl devices
    ;;
    "c"|"connect")
            bluetoothctl connect "$3"
    ;;
    "d"|"disconnect")
            bluetoothctl disconnect "$3"
    ;;
    "p"|"pair")
            bluetoothctl pairable on
            bluetoothctl pair "$3"
            bluetoothclt pairable off
            bluetoothctl trust "$3"
    ;;
    "f"|"full")
            bluetoothctl
    ;;  
    "-h"|"--help"|"help"|"h")
        help
    ;;
esac

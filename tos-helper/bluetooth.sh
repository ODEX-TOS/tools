#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2020 Tom Meyers
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# shellcheck disable=SC2059,SC2154


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
            if [[ "$3" == "off" ]]; then
                rfkill block bluetooth
            else
                rfkill unblock bluetooth
            fi
            if [[ ! -f "$themefile" ]]; then
                mkdir -p "$HOME/.config/tos"
                touch "$themefile"
                printf "off\ntime=1000\nbluetooth=false\n" >>"$themefile"
            fi
            if [[ "$3" == "on" ]]; then
                    res="true"
            else
                    res="false"
            fi
            sed -i 's/^bluetooth=.*$/'"bluetooth=$res"'/' "$themefile"
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
    "-h"|"--help"|"help"|"h"|"")
        help
    ;;
esac


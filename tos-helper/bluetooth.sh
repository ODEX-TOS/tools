#!/bin/bash

case "$2" in
   "s"|"set")
            bluetoothctl power "$3"
    ;;
   "list"|"list")
            if [[ $3 == "scan" ]]; then
                    bluetoothctl scan on &
                    printf "${RED}Press enter if you want to stop scanning${NC}\n"
                    read
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
    "f|full")
            bluetoothctl
    ;;  
esac
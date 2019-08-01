#!/bin/bash

function changemetric {
        if [ "$(id -u)" == "0" ]; then

            echo $1 $2
            current=$(ip route | grep -E "^default .* $1")
            new=$(printf "$current" | sed "s/metric [0-9]*/metric /")"$2"
            ip route del $current
            ip route add $new
        else
                printf "${RED}Only the root user can change the metric${NC}\n"
        fi
}

function listdevices {
    devices=$(ip link show up | awk '$1 ~ /[0-9]*:.*/{printf $2}' | tr ':' ' ')
    for device in $devices; do
            printf "$device $(ip addr show dev $device | awk '$1 ~ /inet|inet6/{printf $1": "$2" " }') Route:  $(ip route show dev $device | head -n1)\n\n"
    done
}

case "$2" in
    "m"|"metric")
        if [[ "$3" == "" || "$4" == "" ]]; then
                    printf "${RED}Can't change metric of specified device because you didn't specifie the device or metric value${NC}"
            else
                    changemetric $3 $4
        fi
    ;;
    "d"|"device")
        listdevices
    ;;
    "r"|"restart")
        systemctl restart NetworkManager
    ;;
    "c"|"connect")
        if [[ "$3" != "" ]]; then
            nmcli dev wifi connect -a "${@:3}"
        fi
    ;;
    "l"|"list")
        nmcli d wifi list
    ;;
esac

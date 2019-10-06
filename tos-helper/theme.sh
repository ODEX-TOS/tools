#!/bin/bash
themefile="$HOME/.config/tos/theme"
function help {
        subname="theme"
        printf "${ORANGE} $name $subname ${NC}OPTIONS: set | add | delete | random | list | time | help\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name $subname help \t\t\t\t Show this help message\n"
        printf "$name $subname set <picture>\t\t\t set the current theme based on a picture\n"
        printf "$name $subname add <picture>\t\t\t Add a theme to the randomizer\n"
        printf "$name $subname delete <picture>\t\t Delete a theme from the randomizer\n"
        printf "$name $subname random <on|off>\t\t Set random theme on or off\n"
        printf "$name $subname list\t\t\t\t List all pictures used for the random theme generator\n"
        printf "$name $subname time <seconds>\t\t Set the timeout between random themes\n"
}

function theme {
    if [[ ! "$(command -v wal)" ]]; then
        yay -Syu python-pywal
    fi
    wal -i "$1"
    if [[ "$(command -v feh)" ]]; then
        feh --bg-scale "$1"
    fi
}

function theme-check {
    if [[ ! -f "$themefile" ]]; then
        mkdir -p "$HOME"/.config/tos
        touch "$themefile"
        printf "off\ntime=1000\n" >> "$themefile"
    else
        sed -i -r '/^\s*$/d' "$themefile"
    fi
    # TODO: change this into a cronjob or real daemon
    # TODO: current check to see if a daemon exists always returns true
    process=$(ps -aux)
    if [[ "$(echo "$process" | grep 'tos theme daemon')" != *'tos theme daemon'* ]]; then
       echo "No daemon found. Launching a new instance"
       nohup tos theme daemon &> /dev/null & # launch theme daemon when it isn't running
    fi
}

function theme-add {
        readlink -f "$1" >> "$themefile"
}

function theme-delete {
        file=$(readlink -f "$1")
        sed -i 's;'"$file"';;g' "$themefile"
        sed -i -r '/^\s*$/d' "$themefile"
}

function theme-random {
        sed -i 's/^on$/'"$1"'/' "$themefile"
        sed -i 's/^off$/'"$1"'/' "$themefile"
}

function gettime {
    if [[ "$1" == "" ]]; then
            echo -e -n "0"
            return
    fi
    echo -e -n "$1"
}

function daemon {
    while true; do
                file=$(shuf -n 1 "$themefile")
                if [[ "$(head -n1 "$themefile")" == "on" ]]; then
                    while [ ! -f "$file" ] || [ "$file" == "" ]; do
                        file=$(shuf -n 1 "$themefile")
                    done
                    head -n1 "$themefile"
                    wal -i "$file"
                fi
                time=$(head -n2 "$themefile" | tail -n1 | awk -F= '{print $2}')
                sleep "$time"
        done
}


case "$2" in
    "s"|"set")
        theme-check
        theme "$3"
    ;;
    "a"|"add")
        theme-check
        theme-add "$3"
    ;;
    "d"|"delete")
        theme-check
        theme-delete "$3"
    ;;
    "r"|"random")
        theme-check
        theme-random "$3"
    ;;
    "daemon")
        daemon
    ;;
    "l"|"list")
        theme-check
        awk '$0 !~ /^off|^on|^\n|time=[0-9]*/{print $0}' "$themefile" | sed -r '/^\s*$/d'
    ;;
    "t"|"time")
        theme-check
        day=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /d/){ printf ($0-d)*24*60*60}}')
        hour=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /h/){ printf ($0-h)*60*60}}')
        minute=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /m/){ printf ($0-m)*60}}')
        second=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /s|^[0-9]*$/){ printf ($0-s)}}')
        total=$(($(gettime "$day") + $(gettime "$hour") + $(gettime "$minute") + $(gettime "$second")))
        sed -i 's/^time=[0-9]*/time='"$total"'/g' "$themefile"
    ;;
    "-h"|"--help"|"help"|"h")
        help
    ;;   
esac

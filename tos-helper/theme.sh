#!/bin/bash

function theme {
    if [[ "$(which wal)" != "/usr/bin/wal" ]]; then
        yay -Syu python-pywal
    fi
    wal -i $1
}

function theme-check {
    if [[ ! -f $themefile ]]; then
        mkdir -p $HOME/.config/tos
        touch $themefile
        printf "off\ntime=1000\n" >> $themefile
    else
        sed -i -r '/^\s*$/d' $themefile
    fi
    # TODO: change this into a cronjob or real daemon
    # TODO: current check to see if a daemon exists always returns true
    process=$(ps -aux)
    if [[ "$(echo $process | grep 'tos theme daemon')" != *'tos theme daemon'* ]]; then
       echo "No daemon found. Launching a new instance"
       nohup tos theme daemon &> /dev/null & # launch theme daemon when it isn't running
    fi
}

function theme-add {
        echo $(readlink -f $1) >> $themefile
}

function theme-delete {
        file=$(readlink -f $1)
        sed -i 's;'$file';;g' $themefile
        sed -i -r '/^\s*$/d' $themefile
}

function theme-random {
        sed -i 's/^on$/'$1'/' $themefile
        sed -i 's/^off$/'$1'/' $themefile
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
                file=$(shuf -n 1 $themefile)
                if [[ "$(cat $themefile | head -n1)" == "on" ]]; then
                    while [ ! -f $file ] || [ "$file" == "" ]; do
                        file=$(shuf -n 1 $themefile)
                    done
                    echo $(cat $themefile | head -n1)
                    wal -i $file
                fi
                time=$(cat "$themefile" | head -n2 | tail -n1 | awk -F= '{print $2}')
                sleep "$time"
        done
}


case "$2" in
    "s"|"set")
        theme-check
        theme $3
    ;;
    "a"|"add")
        theme-check
        theme-add $3
    ;;
    "d"|"delete")
        theme-check
        theme-delete $3
    ;;
    "r"|"random")
        theme-check
        theme-random $3
    ;;
    "daemon")
        daemon
    ;;
    "l"|"list")
        theme-check
        cat $themefile | awk '$0 !~ /^off|^on|^\n|time=[0-9]*/{print $0}' | sed -r '/^\s*$/d'
    ;;
    "t"|"time")
        theme-check
        day=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /d/){ printf ($0-d)*24*60*60}}')
        hour=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /h/){ printf ($0-h)*60*60}}')
        minute=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /m/){ printf ($0-m)*60}}')
        second=$(echo "$3" | sed 's/-/\n/g' | awk '{if($0 ~ /s|^[0-9]*$/){ printf ($0-s)}}')
        total=$(($(gettime $day) + $(gettime $hour) + $(gettime $eminute) + $(gettime $second)))
        sed -i 's/^time=[0-9]*/time='$total'/g' $themefile
    ;;
esac

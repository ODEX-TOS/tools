#!/bin/bash

case "$2" in
    "get"|"g")
        amixer get Master
    ;;
    "c"|"change")
            num=$(echo -e "$3" | tr '-' ' ' | tr '+' ' ' | sed 's/\s*//g')
            echo $num, $3
            if [[ "$2" == *-* ]]; then
                amixer -q sset Master "$num"%-
            else
                amixer -q sset Master "$num"%+
            fi
    ;;
    "s"|"set")
        amixer -q sset Master "$3"%
    ;;
    "t"|"toggle")
        amixer -q set Master toggle
    ;;
esac
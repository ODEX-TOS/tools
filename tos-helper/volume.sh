#!/bin/bash
function help {
        subname="volume"
        printf "${ORANGE} $name $volume ${NC}OPTIONS: get | set | change | toggle | help\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name $subname help \t\t\t\t Show this help message\n"
        printf "$name $subname get \t\t\t\t\t Get the current state of the speaker\n"
        printf "$name $subname set <percent>\t\t\t Set the volume to x percent\n"
        printf "$name $subname change <percent>\t\t\t Change the current volume by x percent eg +3 or -3\n"
        printf "$name $subname toggle \t\t\t\t Toggles the volume on or off\n"
}

case "$2" in
    "get"|"g")
        amixer get Master
    ;;
    "c"|"change")
            num=$(echo -e "$3" | tr '-' ' ' | tr '+' ' ' | sed 's/\s*//g')
            echo "$num, $3"
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
    "-h"|"--help"|"help"|"h")
        help
    ;;   
esac

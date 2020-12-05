#!/bin/bash
START_LOC="2"
MENU_DEFAULT="\e[30;32m[ "
CURRENT_SELECTION="➡"
END="\e[0m"
ERROR="\e[30;31m ERROR 🔴 "
BOTTOM_OFFSET="1"
DIR="$(dirname $0)/tree"


trap cleanup INT

function bottomLine() {
    [[ -z $1 ]] && return
    [[ -z $2 ]] && return
    tput clear
    tput cup $(expr $(tput lines) - $1)
    echo -ne " \e[30;47m 0-9 \e[0m Menu Item    "
    echo -ne " \e[30;47m + \e[0m Show shell script   "
    echo -ne " \e[30;47m . \e[0m Redraw   "
    echo -ne " \e[30;47m / or q \e[0m Quit  "
    tput cup "$2"
}

# $1 is the text you wish to display as a menu item
# $2 the char to press
# $3 is the style of the menu item
# $4 is the position of the menu item
function menuItem {
       tput cup "$4"
       echo -ne "$3$2 ]$END $1" 
}


function drawMenu {
        loc="2"
        char="-1"
        for item in $(ls "$DIR/"*.sh); do
            item=$(basename "$item" .sh)
            char=$(($char + 1))
            if [[ "$char" == "$1" ]]; then
                menuItem "$item"  "$CURRENT_SELECTION $char" "$MENU_DEFAULT" "$loc"
            else    
                menuItem "$item" "$char" "$MENU_DEFAULT" "$loc"
            fi
            loc=$(expr "$loc" + 2)
        done
        if [[ $2 != "" ]]; then
            tput cup "$loc"
            echo -ne "$ERROR $2 $END"
        fi
        echo
}

# $1 is the current selected menuItem (starting from 0)
# $2 is a potential error message
function draw {
    tput clear
    bottomLine "$BOTTOM_OFFSET" "$START_LOC"
    drawMenu "$1" "$2"
}


# $1 is the menu item number that should be executed
function opening {
    # clear the screen so users can see the output of their choice
    tput clear
    loc="0"
    for item in $(ls "$DIR/"*.sh); do
        if [[ "$loc" == "$1" ]]; then
                bash "$item"
                break
        fi
        loc=$(expr "$loc" + 1)
    done
}

# $1 is the menu item number of which we should show the code
function showsource {
    # clear the screen so users can see the output of their choice
    tput clear
    loc="0"
    for item in $(ls "$DIR/"*.sh); do
        if [[ "$loc" == "$1" ]]; then
                "$EDITOR" "$item"
                break
        fi
        loc=$(expr "$loc" + 1)
    done
}

function main() {
    [[ -d "$DIR" ]] || exit 1
    CURRENT="0"
    # mark the cursor as invisible
    tput civis
    draw "$CURRENT"
    while true; do
        read -n 1 out
        case "$out" in
            [0-9])
                opening "$out"
                CURRENT="$out"
                draw "$CURRENT"
                ;;
            "")
                opening "$CURRENT"
                draw "$CURRENT"
                ;;

            A)
                CURRENT=$((CURRENT - 1))
                if [[ "$CURRENT" -lt 0 ]]; then
                        CURRENT="0"
                fi
                draw "$CURRENT"
                ;;
            B)
                CURRENT=$((CURRENT + 1))
                if [[ "$CURRENT" -ge "$(ls "$DIR/"*.sh | wc -l)" ]]; then
                        CURRENT="$(expr $(ls "$DIR/"*.sh | wc -l) - 1)"
                fi
                draw "$CURRENT"
                ;;
            "/"|"q")
                cleanup
                exit 0
                ;;
            ".")
                draw "$CURRENT"
                ;;
            "+")
                showsource "$CURRENT"
                draw "$CURRENT"
                ;;
            *)
                draw "$CURRENT" "Unknown option: $out" 
                ;;
        esac
    done
}

function cleanup {
    tput cnorm
    tput clear
    exit 0
}

main
cleanup

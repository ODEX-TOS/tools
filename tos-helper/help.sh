#!/bin/bash
function help {
        printf "${ORANGE} $name ${NC}OPTIONS: bluetooth|network|screen|theme|volume -c -h -rs -u -Q -R- -S -iso\n\n" "${ORANGE}" "$name" "${NC}"

}


case "$1" in
    ""|"-h"|"--help")
    help
    ;;
esac

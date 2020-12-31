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
        subname="volume"
        printf "${ORANGE} $name $subname ${NC}OPTIONS: get | set | change | toggle | help\n\n" 
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
    "-h"|"--help"|"help"|"h"|"")
        help
    ;;   
esac


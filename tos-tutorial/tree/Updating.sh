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

# shellcheck disable=SC2145,2059


YELLOW='\033[1;33m'
GREEN='\033[0;32m'

NC='\033[0m'

function load {
    i=1
    sp="/-\|"
    echo -e "Waiting for you to execute command: $YELLOW\`$@\`$NC"
    echo -n ' '
    echo -e "$YELLOW"
    # executed command
    while ! pgrep -f "$1" &>/dev/null
    do
        # shellcheck disable=SC2012
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    # wait for command to finish
    clear
    echo -e "${GREEN}Good job! $NC"
    echo "Now finish the command"
    echo -e "$YELLOW"
    while pgrep -f "$1" &>/dev/null
    do
        # shellcheck disable=SC2012
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    clear
}


echo "Welcome to the updater tutorial"
read -r -p "Press enter to continue"
clear

echo -e "You can perform a full system update"

echo -e "To update you can invoke the $YELLOW\`system-updater\`$NC command in a terminal"

sleep 1

load "system-updater"

echo -e "Lets take a look at some common installation commands"
echo
echo -e "Firstly to get a list of all installed applications do $YELLOW\`tos -Q\`$NC"

load "tos -Q"

echo -e "As you can see it provides a big list of installed applications with their version"
read -r -p "Press enter to continue"
clear

echo -e "Lets inspect the $YELLOW\`linux-tos\`$NC package, to gets it's information invoke $YELLOW\`tos -Qi linux-tos\`$NC"

load "tos -Qi linux-tos"

echo -e "Great, inspect all the values associated with the application"
read -r -p "Press enter to continue"
clear

echo -e "Now we are going to show you how to search for a new application"
echo -e "Simply type $YELLOW\`tos -Ss 'application name'\`$NC, in this tutorial we will install $YELLOW\`asciiquarium\`$NC"

load "tos -Ss asciiquarium"

echo -e "If you look into the output you can find $YELLOW\`community/asciiquarium\`$NC"
echo -e "That is the tool we need"
read -r -p "Press enter to continue"
clear

echo -e "Great, lets install it with the command $YELLOW\`tos -S asciiquarium\`$NC"

load "tos -S asciiquarium"

echo -e "You can now invoke the command in your terminal using its name"

load "asciiquarium"

echo "Now lets uninstall the application"

echo -e "Uninstalling is as easy as executing the command $YELLOW\`tos -Rns asciiquarium\`$NC"

load "tos -Rns asciiquarium"

echo -e "If you execute the command again you will see it no longer works"
read -r -p "Press enter to continue"
clear

echo -e "${GREEN}Great job finishing the tutorial!$NC"
read -r 

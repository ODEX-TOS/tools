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
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

NC='\033[0m'

function loadcommand {
    i=1
    sp="/-\|"
    echo -e "Waiting for you to execute command: $YELLOW\`$@\`$NC"
    echo -n ' '
    echo -e "$YELLOW"
    # executed command
    while ! pgrep -f "$1" &>/dev/null
    do
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

function loadtde {
    i=1
    sp="/-\|"
    echo -n ' '
    echo -e "$YELLOW"
    # executed command
    while [[ $(tde-client "$1" | awk '{printf $'"$2"'}') == "$3" ]] &>/dev/null
    do
        # shellcheck disable=SC2012
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    clear
}

function load {
    i=1
    sp="/-\|"
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
    clear
}


function loadcountbigger {
    i=1
    sp="/-\|"
    echo -n ' '
    echo -e "$YELLOW"
    # executed command
    while [[ "$(ps -aux | grep -c " $1$")"  -lt "$2" ]] &>/dev/null
    do
        # shellcheck disable=SC2012
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    clear
}

function loadcountsmaller {
    i=1
    sp="/-\|"
    echo -n ' '
    echo -e "$YELLOW"
    # executed command
    while [[ "$(ps -aux | grep -c " $1$")"  -gt "$2" ]] &>/dev/null
    do
        # shellcheck disable=SC2059
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    clear
}


echo "Welcome to the TDE Tutorial"
echo -e "This will cover basic usage of ${YELLOW}TDE$NC"
read -r -p "Press enter to continue"
clear

echo -e "Open up the application launcher by using $YELLOW\`Super+D (Windows Key + D)\`$NC and type in $YELLOW\`terminal\`$NC"

load "rofi"

echo -e "Now open 3 different terminals by pressing $YELLOW\`Super+Enter (Windows Key + Enter)\`$NC"

loadcountbigger "${TERMINAL:-st}" "3"

echo -e "Do you notice how they tile?"

echo -e "Press $YELLOW\`Super+Spacebar\`$NC a couple of times"
read -r -p "Press enter to continue"
clear

echo -e "You can also stop programs using $YELLOW\`Super+Q\`$NC Keep only one terminal open"
loadcountsmaller "${TERMINAL:-st}" "1"


echo -e "Open up the settings application either by searching for it using $YELLOW\`Super + D\`$NC or by launching it directly with $YELLOW\`Super + S\`$NC"
loadtde "return root.elements.settings.visible" "2" "false"
echo -e "${GREEN}Nice job!$NC In the setting application you can modify general settings of tos"
read -r -p "Press enter to continue"
clear

echo -e "Open a second terminal next to this one by pressing $YELLOW\`Super + Enter\`$NC"
loadcountbigger "${TERMINAL:-st}" "2"
echo -e "You can change focus between these applications by using $YELLOW\`Super + <ArrowKey>\`$NC, for example $YELLOW\`Super + Left\`$NC"
echo -e "Change focus to the new terminal"
W_PID=$(tde-client "return client.focus.pid" | awk '{printf $2}')
loadtde "return client.focus.pid" "2" "$W_PID"
echo -e "${GREEN}Very good!$NC Now that you know how to change focus we can start to talk about moving applications around"
read -r -p "Press enter to continue"
clear

echo -e "Moving applications around is the same as changing focus instead you use the ${YELLOW}Shift$NC key as well"
echo -e "Move the currently focused application by using $YELLOW\`Super + Shift + <ArrowKey>\`$NC, for example $YELLOW\`Super + Shift + Left\`$NC"
X=$(tde-client "return client.focus.x" | awk '{printf $2}')
loadtde "return client.focus.x" "2" "$X"
echo -e "${GREEN}You are wonderfull$NC Now you can move applications around 🤩"
read -r -p "Press enter to continue"
clear

echo -e "You can also put applications into floating mode, this mode behaves as a normal desktop, where you can drag and drop windows around"
echo -e "To put an application into floating mode press $YELLOW\`Super + c\`$NC"
loadtde "return client.focus.floating" "2" "false"
echo -e "${GREEN}Great$NC You can move the application around as normal"
echo -e "Press the key combination again $YELLOW\`Super + c\`$NC to disable floating mode again"
loadtde "return client.focus.floating" "2" "true"
echo -e "${GREEN}Great$NC"
read -r -p "Press enter to continue"
clear

currenttag=$(tde-client "return awful.screen.focused().selected_tag.index" | awk '{printf $2}')
echo -e "You can switch desktops using $YELLOW\`Super + <number>\`$NC for example switch to desktop 5 using $YELLOW\`Super + 5\`$NC"
echo -e "Don't forget to switch back to this workspace by pressing $YELLOW\`Super + $currenttag\`$NC"
loadtde "return awful.screen.focused().selected_tag.index" "2" "$currenttag"
notify-send "TUTORIAL" "Don't forget to switch back to this workspace by pressing \`Super + $currenttag\`"
echo -e "${GREEN}Nice job!$NC By default we have 9 different desktops that you can switch between"
read -r -p "Press enter to continue"
clear

currenttag_app=$(tde-client "return client.focus.screen.selected_tag.index" | awk '{printf $2}')
echo -e "The last part of the tutorial we will show is how to move applications to other desktops"
echo -e "Much like moving an application inside the same desktop you can move them to another desktop"
echo -e "This is done by pressing $YELLOW\`Super + Shift + <number>\`$NC, for example $YELLOW\`Super + Shift + 5\`$NC to move the current application to desktop 5"
loadtde "return client.focus.screen.selected_tag.index" "2" "$currenttag_app"
echo -e "${GREEN}Great!${NC}"
read -r -p "Press enter to continue"
clear

echo -e "${GREEN}Great job finishing the tutorial!$NC"
echo -e "${GREEN}You now know everything needed to manage ${YELLOW}TDE${GREEN}!$NC"

read -r

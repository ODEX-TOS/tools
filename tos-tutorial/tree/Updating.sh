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
        printf "\b${sp:i++%${#sp}:1}"
        sleep 0.05
    done
    echo -e "$NC"
    clear
}


echo "Welcome to the updater tutorial"
read -p "Press enter to continue"
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
read -p "Press enter to continue"
clear

echo -e "Lets inspect the $YELLOW\`linux-tos\`$NC package, to gets it's information invoke $YELLOW\`tos -Qi linux-tos\`$NC"

load "tos -Qi linux-tos"

echo -e "Great, inspect all the values associated with the application"
read -p "Press enter to continue"
clear

echo -e "Now we are going to show you how to search for a new application"
echo -e "Simply type $YELLOW\`tos -Ss 'application name'\`$NC, in this tutorial we will install $YELLOW\`asciiquarium\`$NC"

load "tos -Ss asciiquarium"

echo -e "If you look into the output you can find $YELLOW\`community/asciiquarium\`$NC"
echo -e "That is the tool we need"
read -p "Press enter to continue"
clear

echo -e "Great, lets install it with the command $YELLOW\`tos -S asciiquarium\`$NC"

load "tos -S asciiquarium"

echo -e "You can now invoke the command in your terminal using its name"

load "asciiquarium"

echo "Now lets uninstall the application"

echo -e "Uninstalling is as easy as executing the command $YELLOW\`tos -Rns asciiquarium\`$NC"

load "tos -Rns asciiquarium"

echo -e "If you execute the command again you will see it no longer works"
read -p "Press enter to continue"
clear

echo -e "${GREEN}Great job finishing the tutorial!$NC"
read 

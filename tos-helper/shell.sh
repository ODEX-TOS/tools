#!/bin/bash

# MIT License
# 
# Copyright (c) 2019 Meyers Tom
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

trap ctrl_c INT
# Default values
DELETE="1"
RUN="sh"
GUI="0"
MOUNT="0"
PACKAGE="$RUN"

function help {
        subname="shell"
        printf "${ORANGE} $name $subname ${NC}OPTIONS: [ run | list ] [ --gui | --filesystem | --mount | --save ] packagename [ executable ]\n\n" 
        printf "${ORANGE}USAGE:${NC}\n"
        printf "$name $subname <packagename> \t\t\t\t Run packagename in an isolated environment\n"
        printf "$name $subname <packagename> <executable> \t\t\t Install packagename in an isolated environment but run executable as the option\n"
        printf "$name $subname --gui <packagename>\t\t\t\t Run the package in gui mode\n"
        printf "$name $subname --mount <path> <packagename> \t\t\t Mount a specfic path of the hostsystem to the isolated env\n"
        printf "$name $subname --save <packagename> \t\t\t\t Save the current command for later use\n"
        printf "$name $subname run <id> \t\t\t\t\t Run a saved command\n"
        printf "$name $subname rm <id> \t\t\t\t\t Remove id\n"
        printf "$name $subname clean \t\t\t\t\t Remove everything from the cache\n"
        printf "$name $subname list \t\t\t\t\t\t List all saved commands\n"

        printf "\n${ORANGE}EXAMPLE:${NC}\n"
        printf "$name $subname asciiquarium \t\t\t\t\t Run asciiquarium (terminal app) in an isolated environment\n"
        printf "$name $subname --gui firefox \t\t\t\t Run firefox in an isolated environment and show the user interface (gui)\n"
        printf "$name $subname --gui awesome-tos awesome \t\t\t Install awesome-tos in an isolated environment but run the command awesome (in a gui)\n"
        printf "$name $subname --gui --mount \$(pwd) thunar \t\t\t Mount \$(pwd) to the working directory of the isolated environment and open it in thunar (filebrowser)\n"
        printf "$name $subname --save --gui --mount \$(pwd) thunar \t\t Run the command and save the environment for later use\n"

}

function spinner()
{
    local pid="$1"
    local delay=0.1
    local spinstr='|/-\'
    local loadtime=0
    while [[ "$(ps a | awk '{print $1}' | grep $pid)" ]]; do
        local temp=${spinstr#?}
        loadtime="$(awk -v loadtime="$loadtime" -v delay="$delay" 'BEGIN {print loadtime + delay; exit}')"
        printf " [%c]  %.0fs" "$spinstr" "$loadtime" 2>/dev/null
        local spinstr=$temp${spinstr%"$temp"}
        sleep "$delay"
        printf "\r"
    done
    printf "    \r"
}

function list() {
    if [[ -f "/var/cache/tos-shell/$USER.list" ]]; then
        num="0"
        while read line; do
            local num=$(( $num + 1 ))
            SIZE="$(env $line sh -c 'sudo du -chs "$DIR" | tail -n1 | cut -f1')"
            if echo "$line" | grep -q "MOUNT=0"; then
                env $line SIZE="$SIZE" ID="$num" sh -c 'echo "ID: $ID -- Command: $RUN, Filesystem size: $SIZE"'
            else
                env $line SIZE="$SIZE" ID="$num" sh -c 'echo "ID: $ID -- Command: $RUN, Mountpoint: $MOUNT -> /data, Filesystem size: $SIZE"'
            fi
        done <"/var/cache/tos-shell/$USER.list"
    fi
}

function clean() {
    if [[ -f "/var/cache/tos-shell/$USER.list" ]]; then
        while read line; do
            env $line sudo sh -c 'rm -rf "$DIR"'
        done <"/var/cache/tos-shell/$USER.list"
        sudo rm "/var/cache/tos-shell/$USER.list"
        sudo touch "/var/cache/tos-shell/$USER.list"
    fi
}

function remove() {
    if [[ -f "/var/cache/tos-shell/$USER.list" ]]; then
        local num="0"
        while read line; do
            num=$(( $num + 1 ))
            if [[ "$num" == "$1" ]]; then
                env $line sudo sh -c 'rm -rf "$DIR"'
                # remove line
                awk -v num="$num" '!(num == NR){print $0}' "/var/cache/tos-shell/$USER.list" > temp && sudo mv temp "/var/cache/tos-shell/$USER.list"
                break
            fi
        done <"/var/cache/tos-shell/$USER.list"
    fi
}

function arg_parse(){
    case "$2" in
        "list"|"l")
            list
            exit 0
        ;;
        "rm"|"r")
            remove "$3"
            exit 0
        ;;
        "clean"|"c")
            clean
            exit 0
        ;;
        "run"|"r")
            echo "Running: $3"
            RUNSAVED="$3"
            export $(env -i $(awk "NR==$3{print}" "/var/cache/tos-shell/$USER.list"))
            # remove all $ options
            while true; do
                case "$2" in
                "")
                    break
                ;;
                *)
                    shift
                ;;
                esac
            done

        ;;
        "-h"|"--help"|"help"|"h"|"")
            help
            exit 0
        ;;   
    esac

    while true; do
    case "$2" in
        "--gui"|"-g")
            # TODO: check if Xephyr is installed
            GUI="1"
            shift
        ;;
        "--mount"|"-m")
            MOUNT="$3"
            shift
            shift
        ;;
        "--save"|"-s")
            SAVE="1"
            # Dont delete the environment
            DELETE="0"
            shift
        ;;
        "")
            break
        ;;
        *)
            PACKAGE="${2-$PACKAGE}"
            # TODO: arguments should be supported
            RUN="${3-$2}"
            break
        ;;
    esac
    done
}

function validate_user(){

    if [[ "$(id -u)" == "0" ]]; then
        printf "${RED}We will ask for root privileges when needed${NC}\n"
        exit 1
    fi
    # temporary escalate privileges so it doesn't happen in a background job
    echo "Elevating privileges"
    sudo printf ""
}

function validate_command() {
    if [[ -z "$PACKAGE" ]]; then
        echo "Declare a package to run"
        exit 1
    fi
    if ! pacman -Ss "^$PACKAGE\$" &>/dev/null; then
        echo "Package cannot be installed, since it doesn't exist"
        printf "If you feel this is a mistake you can enter the environment by executing ${ORANGE}tos shell bash${NC}\n"
        exit 1
    fi
}

function generate_env() {
    DIR=$(mktemp -d -p $HOME/.cache)

    echo "Preparing isolated environment"

    sudo pacstrap -c "$DIR" base "$PACKAGE" 1>/dev/null &
    spinner "$!"

    # working directory
    sudo mkdir "$DIR/data"
}

function prepare_env() {
    AUTH="$HOME/.Xauthority"

    if [[ -z "$RUNSAVED" ]]; then
        generate_env
    fi

    # The mount directory exists
    if [[ -d "$MOUNT" ]]; then
        sudo mount --rbind "$MOUNT" "$DIR/data"
    elif [[ -f "$MOUNT" ]]; then
        sudo ln "$MOUNT" "$DIR/data"
    fi

    # mount xorg socket so gui apps work
    if [[ "$GUI" == "1" ]]; then
        sudo ln "$AUTH" "$DIR/root/.Xauthority"
        sudo ln /etc/vconsole.conf "$DIR/etc/vconsole.conf"
        Xephyr -resizeable :1 &
    fi
}

function save() {
    if [[ ! "$SAVE" == "1" ]]; then
        return
    fi
    echo "Commiting current state"

    # ensure the config dir exists
    if [[ ! -d "/var/cache/tos-shell" ]]; then
        sudo mkdir -p "/var/cache/tos-shell"
    fi

    # ensure the data for a single user is working
    if [[ ! -f "/var/cache/tos-shell/$USER.list" ]]; then
        sudo touch "/var/cache/tos-shell/$USER.list"
    fi

    # append the current command to the list
    echo "RUN=$RUN DIR=$DIR GUI=$GUI MOUNT=$MOUNT PACKAGE=$PACKAGE DELETE=$DELETE" | sudo tee -a "/var/cache/tos-shell/$USER.list" &>/dev/null
}


function cleanup() {
    # cleanup
    printf "${GREEN}Cleaning up filesystem${NC}\n"
    if [[ -d "$MOUNT" && -d "$DIR/data" ]]; then
        sudo umount "$DIR/data"
    fi
    if [[ "$DELETE" == "1" ]]; then
        sudo rm -rf "$DIR"
    fi
}

function main() {
    arg_parse $@
    validate_user
    validate_command
    prepare_env

    save

    # wrap it in a shell so we have PATH resolving
    DISPLAY=:1 sudo arch-chroot "$DIR" /bin/bash -c "cat /etc/motd; cd /data; $RUN"

    cleanup
}

function ctrl_c() {
        echo "** Trapped CTRL-C"
        cleanup
        exit 0
}

main $@
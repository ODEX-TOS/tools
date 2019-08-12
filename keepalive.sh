#!/bin/bash
function xorg {
    live=$(pgrep --list-full polybar | awk '{print $3}')
    bIsMain=False
    bIsWorkspace=False
    for item in $live
    do
        if [ "$item" == "main" ]; then
                bIsMain=True
        fi

        if [ "$item" == "workspaces" ]; then
                bIsWorkspace=True
        fi
    done
    if [ "$bIsMain" == False ]; then
            nohup polybar main &>/dev/null &
    fi
    if [ "$bIsWorkspace" == False ]; then
            nohup polybar workspaces &> /dev/null &
    fi

}

function wayland { 
    live=$(pgrep --list-name waybar | awk '{print $2}')
    bIsAlive=False
    for item in $live
    do
        if [ "$item" == "waybar" ]; then
                bIsAlive=True
        fi
    done
    if [ "$bIsAlive" == False ]; then
            nohup waybar &>/dev/null &
    fi
}

while true
do
    display=$(pgrep --list-name sway | awk '{print $2}')
    echo "$display"
    if [[ "$display" == "sway" ]]; then
            wayland
    else
            xorg
    fi
    sleep 5
done

#!/bin/bash
function xorg {
    live=$(ps -ax | grep polybar | awk '{print $6}')
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
    live=$(ps -ax | grep waybar | awk '{print $5}')
    bIsAlive=False
    for item in $live
    do
        echo $item
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
    display=$(ps -ax | grep sway)
    display=$(echo $display | awk '{print $5}')
    echo $display
    if [[ "$display" == "sway" ]]; then
            wayland
    else
            xorg
    fi
    sleep 5
done

#!/bin/bash

while true
do
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
    sleep 5
done

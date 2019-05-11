#!/bin/bash

while true
do
    live=$(ps -ax | grep polybar | awk '{print $6}')
    bisMain=false
    bIsWorkspaces=false
    for item in $live
    do
        if [ "$item" == "main" ]; then
            bisMain=true
        fi

        if [ "$item" == "workspaces" ];then
            bIsWorkspaces=true
        fi
    done

    if [ "$bisMain" = false ]; then
        nohup polybar main &> /dev/null &
    fi

    if [ "$bIsWorkspaces" = false ]; then
        nohup polybar workspaces &> /dev/null &
    fi
    sleep 5

done

#!/bin/bash

while true
do
    live=$(ps -ax | grep polybar | awk '{print $6}')
    for item in $live
    do
        if [ "$item" == "main" ]; then
            nohup polybar main &> /dev/null &
        fi

        if [ "$item" == "workspaces" ];then
            nohup polybar workspace &> /dev/null &
        fi
    done
    sleep 5
done

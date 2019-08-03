#!/bin/bash

case "$1" in
    "-c"|"--crypto")
        if [ "$2" == "" ]; then
               ssh-keygen
        else
               ssh-copy-id $2
        fi 
    ;;
esac
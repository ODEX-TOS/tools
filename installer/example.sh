#!/bin/bash
# This source statement must be present at the top of this file
source $framework

# Informe the user of whats about to happen
prmpt "Installing some software"

# install packages to the user system
packages git wget

# Ask the user something "yes" is the default respones
ask "Do you want to install something custom?" "yes"

# $result stores the user respones
if [[ "$result" == "yes" ]]; then
    prmpt "You answered yes"
else
    prmpt "You didn't do what I wanted :( instead you answerd $result "
fi

# download repo.pbfp.xyz to $HOME/test/testfile
# If the directory doesn't exist it will be created
# important dont end the directory with a /
download $HOME/test testfile "https://repo.pbfp.xyz" 

prmpt "The installation is done!!"

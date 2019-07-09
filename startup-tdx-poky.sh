#!/bin/bash

WDIR=/workdir
DISTVAL=poky

# Check if default build directory is setup
if [ -z "$1" ]
then
    BDDIR=build
else
    BDDIR="$1"
fi

# Check if branch is passed as argument
if [ -z "$BRANCH" ]
then
    BRANCH=LinuxImage3.0
fi

# Configure Git if not configured
if [ ! $(git config --global --get user.email) ]; then
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global color.ui false
fi

# Create a directory for Poky
mkdir -p $WDIR/$DISTVAL
cd $WDIR/$DISTVAL

# Initialize if repo not yet initialized
repo status 2> /dev/null
if [ "$?" = "1" ]
then
    repo init -u http://git.toradex.com/toradex-bsp-platform.git -b $BRANCH -m default.xml
    repo sync
fi # Do not sync automatically if repo is setup already

# Initialize build environment
source export

# Accept Freescale/NXP EULA
if ! grep -q ACCEPT_FSL_EULA $WDIR/$DISTVAL/$BDDIR/conf/local.conf
then
    echo 'You have to accept freescale EULA. Read it carefully and then accept it.'
    echo 'Press "space" to scroll down and "q" to exit'
    sleep 3
    less $WDIR/$DISTVAL/layers/meta-freescale/EULA
    while true; do
        read -p "Do you accept the EULA? [y/n] " yn
        case $yn in
            [Yy]* ) echo 'EULA accepted'
                echo 'ACCEPT_FSL_EULA="1"' >> $WDIR/$DISTVAL/$BDDIR/conf/local.conf
                break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done    
fi

# Create image_list.json for Toradex Easy Installer
if [ ! -f $WDIR/$DISTVAL/$BDDIR/image_list.json ]
then
    cp /etc/image_list.json $WDIR/$DISTVAL/$BDDIR/image_list.json
fi

# Only start build if requested
if [ -z "$TARGET" ]
then
    echo "Build enviorment configured"
else
    echo "Build enviorment configured. Building target image $TARGET"
    echo "> MACHINE=$MACHINE bitbake $TARGET"
    MACHINE=$MACHINE bitbake $TARGET
fi

# Spawn a shell
exec bash -i
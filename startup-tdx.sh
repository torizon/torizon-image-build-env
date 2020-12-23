#!/bin/bash

WDIR=/workdir

# CHeck if Distro is set otherwise exit
if [ -z "$DISTRO" ]
then
    echo "Please set DISTRO variable to either 'torizon' or 'bsp'"
    exit 1
fi

# Check if machine is set otherwise exit
if [ -z "$MACHINE" ]
then
    echo "Please set MACHINE variable"
    exit 1
fi

# Check if default build directory is setup
if [ -z "$1" ]
then
    BDDIR=build*
else
    BDDIR="$1"
fi

# Check if branch is passed as argument
if [ -z "$BRANCH" ]
then
    BRANCH=dunfell-5.x.y
fi

if [[ -z "$MANIFEST" && $DISTRO == "torizon" ]]
then
    MANIFEST=torizoncore/default.xml
elif [[  -z "$MANIFEST" && $DISTRO == "bsp" ]]
then
    MANIFEST=tdxref/default.xml
fi

# Configure Git if not configured
if [ ! $(git config --global --get user.email) ]; then
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global color.ui false
fi

# Create a directory for chosen distro
mkdir -p $WDIR/$DISTRO
cd $WDIR/$DISTRO

# Initialize if repo not yet initialized
repo status 2> /dev/null
if [ "$?" = "1" ]
then
    repo init -u https://git.toradex.com/toradex-manifest.git -b $BRANCH -m $MANIFEST
    repo sync
fi # Do not sync automatically if repo is setup already

# Initialize build environment
if [ $DISTRO == 'torizon' ]
then
    MACHINE=$MACHINE source setup-environment
elif [ $DISTRO == 'bsp' ]
then
    . export
fi

# Accept Freescale/NXP EULA
if ! grep -q ACCEPT_FSL_EULA $WDIR/$DISTRO/$BDDIR/conf/local.conf
then
    echo 'You have to accept freescale EULA. Read it carefully and then accept it.'
    echo 'Press "space" to scroll down and "q" to exit'
    sleep 3
    less $WDIR/$DISTRO/layers/meta-freescale/EULA
    while true; do
        read -p "Do you accept the EULA? [y/n] " yn
        case $yn in
            [Yy]* ) echo 'EULA accepted'
                echo 'ACCEPT_FSL_EULA="1"' >> $WDIR/$DISTRO/$BDDIR/conf/local.conf
                break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done    
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

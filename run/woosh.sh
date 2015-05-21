#!/bin/zsh
cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script
. ./hardware.sh

trap "amp_power off" SIGINT SIGTERM
amp_power on
case "$1" in
    1) play media/woosh1.ogg &> /dev/null ;;
    2) play media/woosh2.ogg &> /dev/null ;;
    *) play media/woosh0.ogg &> /dev/null ;;
esac
amp_power off

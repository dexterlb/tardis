#!/bin/zsh

# TODO: make sure only one of these plays at a time
# or not, maybe make amp_power a stack to allow simoultanenus playing?
# TODO: make a safe "play" function that wraps sox play and kills it if it hangs

cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script
. ./hardware.sh

trap "amp_power pop" SIGINT SIGTERM
amp_power push
case "$1" in
    1) play media/woosh1.ogg &> /dev/null ;;
    2) play media/woosh2.ogg &> /dev/null ;;
    *) play media/woosh0.ogg &> /dev/null ;;
esac
amp_power pop

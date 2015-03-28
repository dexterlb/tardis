#!/bin/zsh
cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script

case "$1" in
    1) aplay media/tardis_on.wav &> /dev/null ;;
    *) aplay media/tardis_off.wav &> /dev/null ;;
esac

#!/bin/zsh
cd "$(dirname "$(readlink -f "$0")")"  # go to the dir of the script

case "$1" in
    1) ./play.sh media/woosh1.ogg ;;
    2) ./play.sh media/woosh2.ogg ;;
    *) ./play.sh media/woosh0.ogg ;;
esac

#!/bin/zsh
echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-0/new_device
hwclock -s

trap "exit" INT
/usr/bin/ntpd -gq
sleep 60
while true; do
    /usr/bin/ntpd -gq
    hwclock -w
    sleep 1600
done

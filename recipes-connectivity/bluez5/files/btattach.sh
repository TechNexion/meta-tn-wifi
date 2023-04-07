#!/bin/sh

I=$1

if [ -f /sys/bus/mmc/devices/mmc?\:0001/mmc?\:0001\:1/device ]; then
	WIFIDEV=$(cat /sys/bus/mmc/devices/mmc?\:0001/mmc?\:0001\:1/device)
	case "$WIFIDEV" in
	0x0701)
		/usr/bin/hciattach -t 30 /dev/${I} qca @BAUDRATE@ flow -
		;;
	*)
		/usr/bin/hciattach /dev/${I} any @BAUDRATE@ flow -
		;;
	esac
fi

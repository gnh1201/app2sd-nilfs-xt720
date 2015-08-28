#!/system/bin/sh

#scripted by gnh1201 at gmail dot com

echo "Restore I/O App2SD NILFS2 for XT720"
echo "This script may damage your system. Continue? (y/n)"
read y

if [ $y != "y" ]
then
	echo "Canceled."
	exit 1
fi

echo "Please Wait..."

mount -t yaffs2 -o rw,remount /dev/block/mtdblock6 /system

busybox rm /data/data
busybox cp -rp /system/sd/data /data

echo "OK. Reboot? (y/n)"
read y

if [ $y = "y" ]
then
	echo "Rebooting... Please Wait..."
	reboot
fi

exit 1

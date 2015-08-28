#!/system/bin/sh

#scripted by gnh1201 at gmail dot com

echo "Restore App2SD NILFS2 for XT720"
echo "This script may damage your system. Continue? (y/n)"
read y

if [ $y != "y" ]
then
	echo "Canceled."
	exit 1
fi

echo "Please Wait..."

mount -t yaffs2 -o rw,remount /dev/block/mtdblock6 /system

busybox rm /data/app
busybox cp -r /system/sd/app /data
busybox chmod 777 /data/app

busybox rm /data/dalvik-cache
busybox cp -r /system/sd/dalvik-cache /data
busybox chmod 777 /data/dalvik-cache

busybox rm /data/app-private
busybox cp -r /system/sd/app-private /data
busybox chmod 777 /data/app-private

echo "OK. Reboot? (y/n)"
read y

if [ $y = "y" ]
then
	echo "Rebooting... Please Wait..."
	reboot
fi

exit 1

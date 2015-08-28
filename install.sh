#!/system/bin/sh

#scripted by gnh1201 at gmail dot com (Nam Hyeon, Go)

echo "Install App2SD NILFS2 for XT720"
echo "Backup: /data/data1, app1, app-private1, dalvik-cache1"
echo "This script may damage your system. Continue? (y/n)"
read y

if [ $y != "y" ]
then
	echo "Canceled."
	exit 1
fi

echo "Please Wait..."

mount -t yaffs2 -o rw,remount /dev/block/mtdblock6 /system

if [ -b /dev/block/mmcblk0p2 ]
then
	busybox umount /dev/block/mmcblk0p2
else
	echo "Not Found! /dev/block/mmcblk0p2";
	exit 1
fi

echo "Do you want to format to NILFS2? (y/n)"
read y
if [ $y = "y" ]
then
	touch /etc/mtab
	cp xbin/* /system/xbin
	cp etc/nilfs_cleanerd.conf /system/etc
	chmod 755 /system/xbin/mkfs.nilfs2 /system/xbin/nilfs_cleanerd
	chmod 644 /system/etc/nilfs_cleanerd.conf
	mkfs.nilfs2 /dev/block/mmcblk0p2
fi

echo "Please Wait..."

cp nilfs2.ko /system/lib/modules
busybox insmod /system/lib/modules/nilfs2.ko
mkdir /system/sd

busybox mount -t nilfs2 /dev/block/mmcblk0p2 /system/sd
if [ $? -eq 255 ]
then
	echo "Mount Failed!"
	exit 1
fi

echo "NILFS2 Mount OK! Install App2SD..."

if [ -f /system/bin/mot_boot_mode.bin ]
then
	echo "mot_boot_mode.bin Exists."
	if [ -d /system/bin/boot_script ]
	then
		cp app2sd_mount.sh /system/bin/boot_script
		chmod 755 /system/bin/boot_script/app2sd_mount.sh
	elif [ -f /system/bin/mot_boot_mode ]
	then
		echo "insmod /system/lib/modules/nilfs2.ko" >> /system/bin/mot_boot_mode
		echo "mount -t nilfs2 /dev/block/mmcblk0p2 /system/sd" >> /system/bin/mot_boot_mode
		echo "/system/xbin/nilfs_cleanerd /dev/block/mmcblk0p2" >> /system/bin/mot_boot_mode
	fi
else
	mv /system/bin/mot_boot_mode /system/bin/mot_boot_mode.bin
	cp mot_boot_mode /system/bin
	chmod 755 /system/bin/mot_boot_mode
fi

busybox cp -r /data/app /system/sd
busybox chmod 777 /system/sd/app

busybox cp -r /data/dalvik-cache /system/sd
busybox chmod 777 /system/sd/dalvik-cache

busybox cp -r /data/app-private /system/sd
busybox chmod 777 /system/sd/app-private

busybox mv /data/app /data/app1
busybox ln -s /system/sd/app /data/app

busybox mv /data/dalvik-cache /data/dalvik-cache1
busybox ln -s /system/sd/dalvik-cache /data/dalvik-cache

busybox mv /data/app-private /data/app-private1
busybox ln -s /system/sd/app-private /data/app-private

echo "App2SD OK! Do you want I/O patch? (y/n)"
read y
if [ $y = "y" ]
then
	busybox cp -rp /data/data /system/sd/
	busybox mv /data/data /data/data1
	busybox ln -s /system/sd/data /data/data
	echo "I/O patch OK!"
else
	echo "I/O patch Canceled."
fi

echo "Reboot? (y/n)"
read y

if [ $y = "y" ]
then
	echo "Rebooting... Please Wait..."
	reboot
fi

exit 1

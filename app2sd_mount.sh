#!/system/bin/sh
insmod /system/lib/modules/nilfs2.ko
mount -t nilfs2 /dev/block/mmcblk0p2 /system/sd
/system/xbin/nilfs_cleanerd /dev/block/mmcblk0p2

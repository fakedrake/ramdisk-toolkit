#!/bin/bash

# Exit on first fail
set -o errexit

GID=$(id -G | head -1 | awk '{print $1}')
UMASK=0777

ACTION="$1"
RAMDISK_MOUNT_POINT="ramdisk-mnt/" # FILESYSTEM_ROOT

URAMDISK_IMAGE=${2:-"./uramdisk.image.gz"}
URAMDISK_IMAGE_OUT="${URAMDISK_IMAGE/.gz/.out.gz}"
RAMDISK_IMAGE="ramdisk.image"
# RAMDISK_IMAGE="ramdisk.img"
RAMDISK_IMAGE_GZ="$RAMDISK_IMAGE.gz"

if [ "$ACTION" == "open" ]; then
	if [ ! -d "$RAMDISK_MOUNT_POINT" ]; then
		mkdir $RAMDISK_MOUNT_POINT
	fi
	dd if=$URAMDISK_IMAGE of=./ramdisk.image.gz skip=16 bs=4
	gunzip ramdisk.image.gz
	chmod a+x+ ramdisk.image
#	sudo mount -v -t ramfs -o gid=$GID,uid=$UID,loop,ro ramdisk.image $RAMDISK_MOUNT_POINT
	sudo mount -o loop,rw ramdisk.image $RAMDISK_MOUNT_POINT
elif [ "$ACTION" == "close" ]; then
	sudo umount $RAMDISK_MOUNT_POINT
	gzip $RAMDISK_IMAGE # creates $RAMDISK_IMAGE_GZ
	mkimage -A arm -T ramdisk -C gzip -d $RAMDISK_IMAGE_GZ $URAMDISK_IMAGE_OUT
	echo "Created proper ramdisk!: $URAMDISK_IMAGE_OUT"
	rm -f $RAMDISK_IMAGE_GZ
else
	echo "Unrecongnized command\nAvailable commands:\n\tramdisk.sh open\n\tramdisk.sh close\n"
fi

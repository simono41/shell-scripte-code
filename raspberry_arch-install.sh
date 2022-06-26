#!/usr/bin/env bash
#
set -ex

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    sudo "${0}" "$@"
    exit 0
fi

fdisk -l

read -p "Welches Laufwerk soll beschrieben werden?: [/dev/sda|/dev/sdb] " device

echo "Wipe Device ${device} ..."

sleep 5

wipefs -a -f ${device}
sgdisk -o ${device}

echo "Create new Partition type ..."

sleep 5

bootpartitionnummer=1
rootpartitionnummer=2

sgdisk -a 2048 -n ${bootpartitionnummer: -1}::+1024K -c ${bootpartitionnummer: -1}:"BIOS Boot Partition" -t ${bootpartitionnummer: -1}:ef02 ${device}
sgdisk -a 2048 -n ${rootpartitionnummer: -1}:: -c ${rootpartitionnummer: -1}:"Linux filesystem" -t ${rootpartitionnummer: -1}:8300 ${device}

echo "Create and mount the FAT filesystem..."

sleep 5

mkfs.vfat /dev/sdX1
mkdir boot
mount /dev/sdX1 boot

echo "Create and mount the ext4 filesystem..."

sleep 5

mkfs.ext4 /dev/sdX2
mkdir root
mount /dev/sdX2 root

echo "Download and extract the root filesystem..."

sleep 5

wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz
bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C root
sync

echo "Move boot files to the first partition..."

sleep 5

mv root/boot/* boot

echo "Unmount the two partitions..."

sleep 5

umount boot root


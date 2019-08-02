#!/bin/bash

#Simon Rieger

#\\10.1.1.12\Email\srieger
#
set -ex

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    sudo "$0" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
    exit 0
fi
echo "Als root Angemeldet"
#

#device=$1
#target=$2

while (( "$#" ))
do
    for wort in ${1}
	do
		echo "$wort"
		export ${wort%=*}=${wort#*=}
		echo "Parameter ${wort%=*} = ${wort#*=}"
	done
    shift
done

sleep 5

aptitude install lvm2
sudo modprobe dm-mod
sudo modprobe dm-mirror # Lädt den "mirror"-Treiber welcher für pvmove notwendig ist


function makebackup() {
mkdir tmpstorage
mount ${device} tmpstorage
mkdir target
mount ${target} target
tar -czf tmpstorage/backup.tar.gz target/*
umount target
umount tmpstorage
}

function makelvm() {
pvcreate ${device}
pvcreate ${device1}
pvdisplay
vgcreate server0 ${device}
lvcreate -L50G --name=ext4 server0
lvcreate -L50G --name=xzf server0

parted /dev/server0/ext4 set 1 raid on
parted /dev/server1/ext4 set 1 raid on

mdadm --create /dev/md0 --auto md --level=1 --raid-devices=2 /dev/server0/ext4 /dev/server1/ext4

vgcreate server1 ${device1}
lvcreate -L50G --name=ext4 server1
lvcreate -L50G --name=xfs server1

parted /dev/server0/xfs set 1 raid on
parted /dev/server1/xfs set 1 raid on

mdadm --create /dev/md0 --auto md --level=1 --raid-devices=2 /dev/server0/xfs /dev/server1/xfs

mkfs -L p_debian_ext4 -t ext4 /dev/md0

mkfs -L p_debian_xfs -t xfs /dev/md1

}

function bindsym() {
mount /dev/md0 target
cd target
mkdir boot
mount ${device} boot
mkdir sys proc dev
mount --bind /sys sys
mount --bind /dev dev
mount --bind /proc proc
}

function restorebackup() {
tar -xzf backup.tar.gz -C target
}

function repairbootloader() {
deviceuuid=$(blkid -s UUID -o value ${device})
echo ${deviceuuid} >> target/etc/fstab
echo "Bitte nochmal nachschauen ob noch alte Einträge entfernt werden müssen!!!"
echo "SystemD suckt total sonst rum ^^"
echo "/etc/mkinitcpio.conf in Hooks einfügen lvm2 vor filesystem"

chroot target aptitude install lvm2
chroot target grub-install ${device%?}
chroot target update-grub
chroot target dpkg-reconfigure linux-image-mylinuxversion
}


makebackup
sleep 5
makelvm
sleep 5
bindsym
sleep 5
restorebackup
sleep 5
repairbootloader
lsblk

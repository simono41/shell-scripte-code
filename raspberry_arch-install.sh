#!/usr/bin/env bash
#
set -ex

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    sudo "${0}" "$@"
    exit 0
fi

sfdisk -l

read -p "Welches Laufwerk soll beschrieben werden?: [/dev/sda|/dev/sdb] " device
[[ -z "${device}" ]] && echo "No device is set! Abort..." && exit 1

read -p "If it is a Raspberry Pi version 3 or 4? : [3/4] " version
[[ -z "${version}" ]] && echo "No Version is set! Abort..." && exit 1

echo "Wipe Device ${device} ..."

sleep 5

wipefs -a -f ${device}

echo "Create new Partition type ..."

sleep 5

bootpartitionnummer=1
rootpartitionnummer=2

fdisk ${device} <<EOF
o
p
n
p
1
2048
+200M
J
t
c
n
p
2


J
w
EOF

echo "Create and mount the FAT filesystem..."

sleep 5

mkfs.vfat ${device}${bootpartitionnummer}
mkdir -p boot
mount ${device}${bootpartitionnummer} boot

echo "Create and mount the ext4 filesystem..."

sleep 5

mkfs.ext4 ${device}${rootpartitionnummer}
mkdir -p root
mount ${device}${rootpartitionnummer} root

echo "Download and extract the root filesystem..."

sleep 5

if ! [ -f "ArchLinuxARM-rpi-aarch64-latest.tar.gz" ]; then
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz
fi
bsdtar -xpf ArchLinuxARM-rpi-aarch64-latest.tar.gz -C root
sync

# Before unmounting the partitions, update /etc/fstab for the different SD block device compared to the Raspberry Pi 3
if [ "${version}" -eq "4" ]; then
    sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab
fi

echo "Move boot files to the first partition..."

sleep 5

mv root/boot/* boot
sync

read -p "Weiter mit unmount..."
umount boot root


#!/usr/bin/env bash

# Boot on a NixOS minimal ISO file, create a root password
# !IMPORTANT! Run this script as sudo
# LVM2 and cryptsetup are required (but already installed in NixOS 25.05)
# See: https://nixos.wiki/wiki/Full_Disk_Encryption
# It will create a 512Mo boot and a LUKS partition.
# The encrypted LUKS partition will contain LVM partitions for '/' (50Go), '/home' and a 8Go swap.

# To change TTY keyboard map
#loadkeys fr

# NVMe SSD
DISK_PART="/dev/nvme0n1" # Change me!
DISK_PART1="/dev/nvme0n1p1" # Change me!
DISK_PART2="/dev/nvme0n1p2" # Change me!
# On KVM/QEMU
#DISK_PART="/dev/vda"
#DISK_PART1="/dev/vda1"
#DISK_PART2="/dev/vda2"
parted -l
#lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,UUID

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "UEFI partitionning..."
parted "$DISK_PART" -- mklabel gpt
parted "$DISK_PART" -- mkpart ESP fat32 1MB 512MB
parted "$DISK_PART" -- set 1 esp on
parted "$DISK_PART" -- mkpart system 512MB 100%

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Filesystem formatting..."
mkfs.fat -F 32 -n boot "$DISK_PART1"

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Creating encrypted partition..."
cryptsetup luksFormat -q -y --label nixossystem  "$DISK_PART2"
# open the encrypted partition and map it to /dev/mapper/cryptroot
cryptsetup luksOpen "$DISK_PART2" cryptroot

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Creating LVM volumes..."
pvcreate /dev/mapper/cryptroot
#pvdisplay
# create a volume group inside
vgcreate lvmroot /dev/mapper/cryptroot
#vgdisplay
# create the swap volume
lvcreate --size 8G lvmroot --name swap
# create the root volume (50Go)
lvcreate --size 50G lvmroot --name root
# create a home volume (100% of free disk)
lvcreate -l 100%FREE lvmroot --name home
#lvdisplay

# Filesystem formatting
mkfs.ext4 -L nixos /dev/mapper/lvmroot-root
mkfs.ext4 -L home /dev/mapper/lvmroot-home
mkswap -L swap /dev/mapper/lvmroot-swap

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "System installation..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/home
mount /dev/disk/by-label/home /mnt/home
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
#df -h

nixos-generate-config --root /mnt

parted -l
lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,PARTLABEL,UUID
printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Finishing installation..."

cp ./*.nix /mnt/etc/nixos/

printf "\e[32m You SHOULD now edit /mnt/etc/nixos/configuration.nix to your liking.\e[0m \n"
while true; do

read -r -p "\e[32m When the configuration is set, proceed installation ? (y/n) \e[0m " yn

case $yn in
  [yY] ) echo "nixos-install";
    nixos-install --no-root-passwd
    # Temporary password should be set in configuration.nix
    printf "\e[32m Done...\e[0m \n"
    printf "\e[32m You can now reboot.\e[0m \n"
    break;;
  [nN] ) echo "Exiting...";
    exit;;
  * ) echo "Invalid response";;
esac

done

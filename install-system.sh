#!/usr/bin/env bash

# Boot on a NixOS minimal ISO file, create a root password
# !IMPORTANT! Run this script as sudo
# It will create 3 partitions for '/boot', '/' and a 8Go swap

# To change TTY keyboard map
#loadkeys fr

# NVMe SSD
DISK_PART="/dev/nvme0n1" # Change me!
DISK_PART1="/dev/nvme0n1p1" # Change me!
DISK_PART2="/dev/nvme0n1p2" # Change me!
DISK_PART3="/dev/nvme0n1p3" # Change me!
# On KVM/QEMU
#DISK_PART="/dev/vda"
#DISK_PART1="/dev/vda1"
#DISK_PART2="/dev/vda2"
#DISK_PART3="/dev/vda3"
parted -l
#lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,UUID

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "UEFI partitionning..."
parted "$DISK_PART" -- mklabel gpt
parted "$DISK_PART" -- mkpart ESP fat32 1MB 512MB
parted "$DISK_PART" -- set 1 esp on
parted "$DISK_PART" -- mkpart root ext4 512MB -8GB
parted "$DISK_PART" -- mkpart swap linux-swap -8GB 100%

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Filesystem formatting..."
mkfs.fat -F 32 -n boot "$DISK_PART1"
mkfs.ext4 -L nixos "$DISK_PART2"
mkswap -L swap "$DISK_PART3"

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "System installation..."
mount /dev/disk/by-label/nixos /mnt
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

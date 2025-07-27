#!/usr/bin/env bash

# Boot on a NixOS minimal ISO file, create a root password
# !IMPORTANT! Run this script as sudo
# It will create 3 partitions for '/boot', '/' and a 8Go swap
# OR with --crypt option, it will create a 512Mo boot and a LUKS partition.
# The encrypted LUKS partition will contain LVM partitions for '/' (100Go), '/home' and a 8Go swap.
#
# Usage:
#       ./install-system.sh [options] <disk_partition>
#
# Examples:
# ./install-system.sh /dev/nvme0n1               - Standard install on the first NVMe SSD.
# ./install-system.sh --crypt /dev/nvme0n1       - Full encrypted disk install on the first NVMe SSD.
# ./install-system.sh /dev/vda                   - Standard install on a QEMU disk.

set -e

# Print help function
usage ()
{
  echo -e "
Usage: ./install-system.sh [options] <disk_partition>
  Where,
    disk_partition: Valid /dev path of a disk to install NixOS on.";

  cat << EOF

  Options:
     -h, --help       Print this message.
     --crypt          Full disk encryption with LVM+LUKS.
     --rpi4           Raspberry PI 4 installation. (exclude --crypt option)

  Examples:
    Full encrypted disk install on the first NVMe SSD:
      ./install-system.sh --crypt /dev/nvme0n1
    Standard install on the second HDD:
      ./install-system.sh /dev/sdb
    Standard install on a QEMU/KVM virtual disk:
      ./install-system.sh /dev/vda
    Raspberry Pi 4 install:
      nix-shell -p git raspberrypi-eeprom
      ./install-system.sh --rpi4 /dev/mmcblk1
EOF
  exit;
}

# Scripts arguments
if [ $# -lt 1 ]; then
  usage;
fi;
encrypt_disk=0;
rpi4_install=0;
while getopts ":h-:" opt; do
  case "${opt}" in
    -)
      case "${OPTARG}" in
        crypt) encrypt_disk=1; ;;
        help) usage; ;;
        rpi4) rpi4_install=1; encrypt_disk=0; ;;
        *) usage; ;;
      esac;;
    h) usage; ;;
    *) usage; ;;
  esac
done

# NVMe SSD: /dev/nvme0n1
DISK_PART="${!#}"
if [ ! -e "$DISK_PART" ]; then
  printf "\e[31mDisk path is invalid! \e[0m \n"
  exit 2
fi

# Raspberry Pi 4 install
if [ $rpi4_install -eq 1 ]; then
  # Prepare an SD card
  # Download an SD card image from https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux
  # Unzip it with:
  # zstd -d nixos-image-sd-card-25.05.805977.88983d4b665f-aarch64-linux.img.zst
  # Burn it with Balena Etcher, Caligula or dd
  # sudo dd if=nixos-image-sd-card-25.05.805977.88983d4b665f-aarch64-linux.img of=/dev/sdb bs=10MB oflag=dsync status=progress
  # boot from the SD card, then as root:
  # nix-shell -p git raspberrypi-eeprom
  # cd /tmp
  # git clone https://github.com/VideoCurio/nixos-configuration
  # cd nixos-configuration/
  # ./install-system.sh --rpi4 /dev/mmcblk1
  printf "\e[32mRaspberry Pi 4 installation... \e[0m \n"
  # Updating firmware
  mount /dev/disk/by-label/FIRMWARE /mnt
  BOOTFS=/mnt rpi-eeprom-update -d -a

  cp ./*.nix /etc/nixos/

  nixos-rebuild boot
  printf "\e[32m Done... \e[0m \n"
  printf "\e[32m You can now reboot. \e[0m \n"
  exit 1
fi

if [ $encrypt_disk -eq 1 ]; then
  echo "Disk will be fully encrypted..."
fi

while true; do
read -r -p "Partitioning disk $DISK_PART ? All data will be ERASED (y/n) " yn

case $yn in
  [yY] ) echo "Proceeding...";
    break;;
  [nN] ) echo "Exiting...";
    exit;;
  * ) echo "Invalid response";;
esac
done

# Check if disk exist
if fdisk -l "$DISK_PART"; then
  DISK_PART1="$DISK_PART"1
  DISK_PART2="$DISK_PART"2
  DISK_PART3="$DISK_PART"3
  if [[ $DISK_PART =~ ^"/dev/nvme" ]]; then
    DISK_PART1="$DISK_PART"p1
    DISK_PART2="$DISK_PART"p2
    DISK_PART3="$DISK_PART"p3
  fi
else
  printf "\e[31mDisk %s not found! \e[0m \n" "$DISK_PART"
  exit 2
fi

#parted -l
#lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,UUID

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "UEFI partitionning..."
parted "$DISK_PART" -- mklabel gpt
parted "$DISK_PART" -- mkpart ESP fat32 1MB 512MB
parted "$DISK_PART" -- set 1 esp on
if [ $encrypt_disk -eq 0 ]; then
  parted "$DISK_PART" -- mkpart root ext4 512MB -8GB
  parted "$DISK_PART" -- mkpart swap linux-swap -8GB 100%
else
  parted "$DISK_PART" -- mkpart system 512MB 100%
fi

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Filesystem formatting..."
mkfs.fat -F 32 -n boot "$DISK_PART1"
if [ $encrypt_disk -eq 0 ]; then
  mkfs.ext4 -L nixos "$DISK_PART2"
  mkswap -L swap "$DISK_PART3"
fi

if [ $encrypt_disk -eq 1 ]; then
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
  # create the root volume (100Go)
  lvcreate --size 100G lvmroot --name root
  # create a home volume (100% of free disk)
  lvcreate -l 100%FREE lvmroot --name home
  #lvdisplay

  # Filesystem formatting
  mkfs.ext4 -L nixos /dev/mapper/lvmroot-root
  mkfs.ext4 -L home /dev/mapper/lvmroot-home
  mkswap -L swap /dev/mapper/lvmroot-swap
fi

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "System installation..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
if [ $encrypt_disk -eq 1 ]; then
  mkdir -p /mnt/home
  mount /dev/disk/by-label/home /mnt/home
fi
#df -h

nixos-generate-config --root /mnt

#parted -l
fdisk -l "$DISK_PART"
lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,PARTLABEL,UUID
printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Finishing installation..."

cp ./*.nix /mnt/etc/nixos/

while true; do
read -r -p "Proceed with installation ? (y/n) " yn

case $yn in
  [yY] ) echo "nixos-install";
    nixos-install --no-root-passwd
    # Temporary password should be set in configuration.nix
    printf "\e[32m Done... \e[0m \n"
    printf "\e[32m You can now reboot. \e[0m \n"
    break;;
  [nN] ) echo "Exiting...";
    exit;;
  * ) echo "Invalid response";;
esac
done

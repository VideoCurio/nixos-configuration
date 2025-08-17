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

set -eu

# Print help function
usage ()
{
  echo -e "
Usage: ./install-system.sh [options] <disk_partition>
  Where,
    disk_partition: Valid /dev path of a disk to install NixOS on.
    The default root partition size is set to 80G for full disk encryption option, use --root-size to change this.";

  cat << EOF

  Options:
     -h, --help         Print this message.
     --crypt            Full disk encryption with LVM+LUKS with separated root and /home partitions.
     --root-size SIZE   Set root partition size (e.g., 100G or 20%) - ONLY with --crypt option.
     --rpi4             Raspberry PI 4 installation (exclude --crypt option).
     -v, --verbose      Print more information.

  Examples:
    Full encrypted disk install on the first NVMe SSD (with /home partition):
      ./install-system.sh --crypt --root-size 120G /dev/nvme0n1
    Minimal disk install on the second HDD:
      ./install-system.sh /dev/sdb
    Minimal disk install on a QEMU/KVM virtual disk:
      ./install-system.sh /dev/vda
    Raspberry Pi 4 install:
      nix-shell -p git raspberrypi-eeprom
      ./install-system.sh --rpi4 /dev/mmcblk1
EOF
  exit;
}

do_dotfiles_install=1;
encrypt_disk=0;
root_size="80G"
rpi4_install=0;
verbose=0;

# Function to validate root size format
validate_root_size() {
  local pattern="^[0-9]+([GMm]|%)$"
  if ! [[ "$1" =~ $pattern ]]; then
    printf "\e[31mInvalid root size format. Use 'SIZE[G|M|m]' or 'SIZE%%' (e.g., 100G, 15%% or 80m).\e[0m \n"
    exit 1
  fi
}

# Scripts arguments parse options
ARGS=$(getopt --longoptions="verbose,help,crypt,rpi4,root-size:" --name "$0" --options ":hv" -- "$@")
if [ $# -lt 1 ]; then
  usage
fi;

DISK_PART="${!#}"

eval set -- "$ARGS"

while true; do
  case "$1" in
    -v | --verbose)
      verbose=1
      shift
      ;;
    -h | --help)
      usage
      ;;
    --crypt)
      encrypt_disk=1
      shift
      ;;
    --rpi4)
      rpi4_install=1
      shift
      ;;
    --root-size)
      root_size="$2"
      validate_root_size "$root_size"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

if [ $rpi4_install -eq 1 ]; then
  # disk on RPI4 could not be modified
  encrypt_disk=0
fi

# Check disk path
if [ ! -e "$DISK_PART" ]; then
  printf "\e[31mDisk path is invalid! \e[0m \n"
  exit 2
fi

# Test - debug parameters
if [ $verbose -eq 1 ]; then
  echo "--crypt: $encrypt_disk"
  echo "--rpi4: $rpi4_install"
  echo "--root-size: $root_size"
  echo "<disk_partition>: $DISK_PART"
fi

# This script must be run as root
if [ "$EUID" -ne 0 ]; then
  printf "\e[31mThis script MUST be run as root: sudo ./install-system.sh \e[0m \n" >&2
  exit 1
fi

# Check dependencies
available() { command -v "$1" >/dev/null; }

if ! available git; then
  printf "\e[31mgit command not found! \e[0m \n"
  exit 2
fi

# dotfiles install function
dotfiles-inst () {
  printf "\e[32m================================\e[0m \n"
  printf "\e[32m================================\e[0m \n"
  echo "Custom dotfiles installation..."
  git clone --bare https://github.com/VideoCurio/nixos-dotfiles.git /tmp/dotfiles/
  mkdir -p /mnt/etc/skel/
  git --git-dir=/tmp/dotfiles/ --work-tree=/mnt/etc/skel/ checkout || true
  rm -rf /tmp/dotfiles/
  # Iterate over each home user
  for dir in /mnt/home/*/; do
    if [[ -d "$dir" && "$dir" != "/mnt/home/lost+found/" ]]; then
      echo "Cloning dotfiles into: $dir"
      git clone --bare https://github.com/VideoCurio/nixos-dotfiles.git /tmp/dotfiles/
      git --git-dir=/tmp/dotfiles/ --work-tree="$dir" checkout || true
      chown -R 1000:100 "$dir" # Any way to predict OWNER at this stage ?
      rm -rf /tmp/dotfiles/
    fi
  done
  printf "\e[32mDotfiles installation done.\e[0m\n"
}

# Format disk function
format () {
  printf "\e[32m Formatting disk %s... \e[0m \n" "$DISK_PART"
  if [ $encrypt_disk -eq 1 ]; then
    echo "Disk will be fully encrypted..."
  fi

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
  if [ $verbose -eq 1 ]; then
    lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,UUID
  fi

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
    if [ $verbose -eq 1 ]; then
      pvdisplay
    fi
    # create a volume group inside
    vgcreate lvmroot /dev/mapper/cryptroot
    if [ $verbose -eq 1 ]; then
      vgdisplay
    fi
    # create the swap volume
    lvcreate --size 8G lvmroot --name swap
    # create the root volume
    lvcreate --size "$root_size" lvmroot --name root
    # create a home volume (100% of free disk)
    lvcreate -l 100%FREE lvmroot --name home
    if [ $verbose -eq 1 ]; then
      lvdisplay
    fi

    # Filesystem formatting
    mkfs.ext4 -L nixos /dev/mapper/lvmroot-root
    mkfs.ext4 -L home /dev/mapper/lvmroot-home
    mkswap -L swap /dev/mapper/lvmroot-swap
  fi
}

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
  cp -r hardened/ /etc/nixos/

  nixos-rebuild boot
  printf "\e[32m Done... \e[0m \n"
  printf "\e[32m You can now reboot. \e[0m \n"
  exit 1
fi

while true; do
read -r -p "Partitioning disk $DISK_PART ? All data will be ERASED (y/n) " yn

case $yn in
  [yY] ) format;
    break;;
  [nN] ) echo "Proceeding without disk formatting...";
    break;;
  * ) echo "Invalid response";;
esac
done

if [ $verbose -eq 1 ]; then
  lsblk --fs
fi

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Mounting system..."
sleep 2s
if ! mountpoint -q /mnt; then
  mount /dev/disk/by-label/nixos /mnt
fi
mkdir -p /mnt/boot
if ! mountpoint -q /mnt/boot; then
  mount -o umask=077 /dev/disk/by-partlabel/ESP /mnt/boot
fi
if [[ $(swapon -s | wc -l) -eq 1 ]]; then
  swapon /dev/disk/by-label/swap
fi
if [ $encrypt_disk -eq 1 ]; then
  mkdir -p /mnt/home
  if ! mountpoint -q /mnt/home; then
    mount /dev/disk/by-label/home /mnt/home
  fi
fi

if [ $verbose -eq 1 ]; then
  fdisk -l "$DISK_PART"
  lsblk -lo NAME,SIZE,TYPE,MOUNTPOINTS,PARTLABEL,UUID
fi

echo "Create basic configuration:"
nixos-generate-config --root /mnt --no-filesystems

printf "\e[32m================================\e[0m \n"
printf "\e[32m================================\e[0m \n"
echo "Copying configurations files..."

cp ./*.nix /mnt/etc/nixos/
cp -r modules/ /mnt/etc/nixos/

while true; do
read -r -p "Proceed with installation ? (y/n) " yn

case $yn in
  [yY] ) echo "nixos-install";
    nixos-install --no-root-passwd
    if [ $do_dotfiles_install -eq 1 ]; then
      dotfiles-inst
    fi
    printf "\e[32m Done... \e[0m \n"
    printf "\e[32m You can now reboot. \e[0m \n"
    break;;
  [nN] ) echo "Exiting...";
    exit;;
  * ) echo "Invalid response";;
esac
done

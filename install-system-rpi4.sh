#!/usr/bin/env bash

# Prepare an SD card 
# Download an SD card image from https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux
# Unzip it with:
# zstd -d nixos-image-sd-card-25.05.805977.88983d4b665f-aarch64-linux.img.zst
# Burn it with Balena Etcher or Caligula

# Boot the Pi card with this image, create a nixos user passwd, and connect to thje board via SSH
# Send this script with: scp ./install-system-rpi4.sh nixos@192.168.122.84:/tmp/install-system-rpi4.sh
# ssh nixos@192.168.122.44
# sudo -i
# chmod u+x /tmp/install-system-rpi4.sh
# /tmp/install-system-rpi4.sh

# See: https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4

# Updating firmware
nix-shell -p raspberrypi-eeprom
mount /dev/disk/by-label/FIRMWARE /mnt
BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a

# Copy the rpi4 configuration file to /tmp with:
# scp ./configuration-rpi4.nix nixos@192.168.71.75:/tmp
cp ./*.nix /etc/nixos/

printf "Now edit /mnt/etc/nixos/configuration.nix to your liking.\n"

while true; do

read -r -p "When the configuration is set, proceed installation ? (y/n) " yn

case $yn in
  [yY] ) echo "nixos-rebuild";
    nixos-rebuild boot
    # Temporary password should be set in configuration.nix
    printf "Done...\n"
    printf "You can now reboot.\n"
    break;;
  [nN] ) echo "Exiting...";
    exit;;
  * ) echo "Invalid response";;
esac

done

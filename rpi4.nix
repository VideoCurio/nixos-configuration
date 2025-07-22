# For Raspberry PI 4
# Must be imported by configuration.nix
# REMOVE all other imports in configuration.nix !
# See: https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4
# see: https://github.com/NixOS/nixos-hardware/archive/master.tar.gz

{ config, pkgs, lib, ... }:

{

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi4;
    kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" "usbhid.mousepoll=8" ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "vc4" ];
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  swapDevices = [ ];

  networking = {
    networkmanager.wifi.powersave = false; # Prevent host becoming unreachable on wifi after some time.
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  hardware.deviceTree.filter = lib.mkDefault "bcm2711-rpi-*.dtb";
  # For Wifi mofule firmware
  hardware.enableRedistributableFirmware = true;

}


# LUKS + LVM filesystems
# As defined by 'nixcosmic-install --crypt /dev/XXX'

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.filesystems.luks.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Filesystems with LUKS + LVM as defined by 'nixcosmic-install --crypt /dev/XXX'";
    };
  };

  config = lib.mkIf config.nixcosmic.filesystems.luks.enable {
    boot.initrd.kernelModules = [ "dm-snapshot" "cryptd" ];
    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/nixossystem";

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
  };
}

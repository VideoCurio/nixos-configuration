# Minimal filesystems, partitions for: '/boot', '/' and swap
# As configured by 'nixcosmic-install /dev/XXX'

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.filesystems.minimal.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Minimal filesystems as defined by 'nixcosmic-install /dev/XXX'";
    };
  };

  config = lib.mkIf config.nixcosmic.filesystems.minimal.enable {
    boot.initrd.kernelModules = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
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

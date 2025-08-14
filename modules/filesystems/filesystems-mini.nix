# Minimal filesystems, partitions for: '/boot', '/' and swap
# As configured by install-system.sh

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.filesystems.minimal.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Minimal filesystems as defined by install-system.sh /dev/XXX";
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

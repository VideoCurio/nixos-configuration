# Minimal filesystems, partitions for: '/boot', '/' and swap
# As configured by 'curios-install /dev/XXX'

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    curios.filesystems.minimal.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Minimal filesystems as defined by 'curios-install /dev/XXX'";
    };
  };

  config = lib.mkIf config.curios.filesystems.minimal.enable {
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

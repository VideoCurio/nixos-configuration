# Must be imported by configuration.nix
# Minimal filesystems, partitions for: '/boot', '/' and swap
# As configured by install-system.sh

{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];
}

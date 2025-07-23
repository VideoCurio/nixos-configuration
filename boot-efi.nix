# EFI boot options
# Must be imported by configuration.nix

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;  # Use latest kernel instead of LTS.
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 5; # Limit the number of generations to keep
    };
  };
}

# Networking settings

{ config, lib, pkgs, ... }:
{
  # Declare options
  options = {
    nixcosmic.networking.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NixcOSmic networking options.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.networking.enable {
    networking = {
      wireless.enable = false;  # Enables wireless support via wpa_supplicant OR
      networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    };
  };
}
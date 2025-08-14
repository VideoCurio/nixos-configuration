# Video editing related packages.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.desktop.apps.studio.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop apps related to video edition: obs-studio, audacity, DaVinci Resolve.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.apps.studio.enable {
    # OBS
    programs.obs-studio = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      audacity
      davinci-resolve
    ];
  };
}

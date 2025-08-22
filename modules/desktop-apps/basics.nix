# Basic desktop apps.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.desktop.apps.basics.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "NixcOSmic minimum desktop apps.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.apps.basics.enable {
    environment.systemPackages = with pkgs; [
      caligula

      # Alacritty terminal
      alacritty
      # alacritty-theme

      # 3rd party apps
      bitwarden-desktop
      brave
      easyeffects
      gimp3-with-plugins
      protonvpn-gui
      signal-desktop
      vlc
      yubioath-flutter
    ];

    # Enabling PCSC-lite for Yubikey
    services.pcscd.enable = true;
  };
}

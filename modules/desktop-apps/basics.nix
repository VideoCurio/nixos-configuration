# Basic desktop apps.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    curios.desktop.apps = {
      basics.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "CuriOS minimum desktop apps.";
      };
      appImage.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enabling Linux AppImage.";
      };
    };
  };

  # Declare configuration
  config = lib.mkIf config.curios.desktop.apps.basics.enable {
    environment.systemPackages = with pkgs; [
      caligula

      # Alacritty terminal
      alacritty
      # alacritty-theme

      # 3rd party apps
      bitwarden-desktop
      brave
      easyeffects
      ffmpeg_6-full
      gimp3-with-plugins
      libsecret
      protonvpn-gui
      signal-desktop
      vlc
      yubioath-flutter
    ];

    # Enabling PCSC-lite for Yubikey
    services.pcscd.enable = true;

    # Enabling Linux AppImage
    programs.appimage.enable = lib.mkDefault config.curios.desktop.apps.appImage.enable;
    programs.appimage.binfmt = lib.mkDefault config.curios.desktop.apps.appImage.enable;
  };
}

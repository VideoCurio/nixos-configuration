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
      gparted
      libsecret
      polkit_gnome
      protonvpn-gui
      signal-desktop
      vlc
      yubioath-flutter
    ];

    # Enabling PCSC-lite for Yubikey
    services.pcscd.enable = true;

    # systemd
    systemd = {
      user = {
        # Start polkit_gnome as a systemd service
        services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };

    # Enabling Linux AppImage
    programs.appimage.enable = lib.mkDefault config.curios.desktop.apps.appImage.enable;
    programs.appimage.binfmt = lib.mkDefault config.curios.desktop.apps.appImage.enable;
  };
}

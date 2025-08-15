# COSMIC desktop environment

{ config, lib, pkgs, ... }:
{
  # Declare options
  options = {
    nixcosmic.desktop.cosmic.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable COSMIC desktop environment.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.cosmic.enable {
    environment.systemPackages = with pkgs; [
      #See: https://github.com/lilyinstarlight/nixos-cosmic/blob/main/nixos/cosmic/module.nix
      adwaita-icon-theme
      alsa-utils
      cosmic-ext-tweaks
      fontconfig
      freetype
      hicolor-icon-theme
      jq
      lld
      lswt
      playerctl
      pop-icon-theme
      pop-launcher
      xdg-user-dirs
    ];

    # Env packages
    environment.pathsToLink = [
      "/share/backgrounds"
      "/share/cosmic"
    ];

    # Env variables
    environment.sessionVariables = {
      # Hint Electron apps to use Wayland
      NIXOS_OZONE_WL = "1";
    };

    # Enabling xdg desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-cosmic
      ];
    };

    # Cosmic Desktop Env
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.xwayland.enable = true;

    # Required features
    #hardware.graphics.enable = true;
    services.libinput.enable = true;
    xdg.mime.enable = true;
    xdg.icons.enable = true;
    # Required dbus services
    services.accounts-daemon.enable = true;
    services.upower.enable = true;
    security.polkit.enable = true;
    services.power-profiles-daemon.enable = true;
    services.geoclue2.enable = true;

    # Optional features
    #hardware.bluetooth.enable = true;
    services.acpid.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.dconf.enable = true;
    programs.gnome-disks.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    #services.libinput.enable = true;
  };
}
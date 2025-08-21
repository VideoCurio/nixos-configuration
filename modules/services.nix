# NixcOSmic services base configuration

{ config, lib, pkgs, ... }:
{
  # Declare options
  options = {
    nixcosmic.services.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NixcOSmic services.";
    };
    nixcosmic.services.printing.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CUPS printing services.";
    };
    nixcosmic.services.sshd.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable SSH daemon services.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.services.enable {
    # xserver X11
    services.xserver = {
      enable = lib.mkDefault true;
      # keyboard settings, see: 'localectl status' , 'setxkbmap -query' ?
      xkb.layout = "us";
      xkb.model = "pc105";
      #xkb.options = "eurosign:e,caps:escape";
      displayManager.sessionCommands = "setxkbmap -layout us -variant intl";
    };

    # OpenSSH server.
    services.openssh = {
      enable =
        if config.nixcosmic.services.sshd.enable then
          true
        else
          false;
      settings = {
        PermitRootLogin = "no";
        StrictModes = true;
        PasswordAuthentication = false; # Set users.users.<name>.openssh.authorizedKeys.keys to your ssh pubkey
        KbdInteractiveAuthentication = false;
        PrintMotd = true;
        UsePAM = true;
        X11Forwarding = false;
      };
    };
    # SSH start-agent - not compatible with gnupg.agent SSH
    programs.ssh.startAgent = true;

    # Enable CUPS to print documents.
    services.printing.enable =
      if config.nixcosmic.services.printing.enable then
        true
      else
        false;

    # Enabling Flatpak
    services.flatpak.enable = true;
    # Flatpak system, add repo
    systemd.services.flatpak-repo = {
      enable = true;
      description = "Flatpak add default repos";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script =
        if config.nixcosmic.desktop.cosmic.enable then
          ''
            /run/current-system/sw/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            /run/current-system/sw/bin/flatpak remote-add --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo
          ''
        else
          ''
            /run/current-system/sw/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
          '';
    };
    # Flatpak user auto update
    # systemctl --user list-units --type=service
    systemd.user.services.flatpak-update = {
      enable = true;
      description = "Flatpak user update";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      #path = [ pkgs.flatpak ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/run/current-system/sw/bin/flatpak update --noninteractive --assumeyes";
      };
      wantedBy = [ "default.target" ];
    };
    # systemctl --user list-timers
    # systemctl --user status flatpak-update.timer
    systemd.user.timers.flatpak-update = {
      enable = true;
      description = "Flatpak user update";
      timerConfig = {
        OnBootSec = "2m";
        OnActiveSec = "2m";
        OnUnitInactiveSec = "24h";
        OnUnitActiveSec = "24h";
        AccuracySec = "1h";
        RandomizedDelaySec = "10m";
      };
      wantedBy = [ "timers.target" ];
    };

    # Enable sound.
    #services.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512; # Keep increasing the quant value until you get no crackles
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 16384;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        "context.properties" = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = { };
          }
        ];
        "pulse.properties" = {
          "pulse.min.req" = "256/48000";
          "pulse.default.req" = "512/48000";
          "pulse.max.req" = "512/48000";
          "pulse.min.quantum" = "256/48000";
          "pulse.max.quantum" = "16384/48000";
        };
        "stream.properties" = {
          "node.latency" = "512/48000";
          "resample.quality" = 1;
        };
      };
    };
    security.rtkit.enable = true; # realtime scheduling priority for pipewire.
  };
}
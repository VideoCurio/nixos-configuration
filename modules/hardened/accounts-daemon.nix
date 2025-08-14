{ config, lib, ... }:

{
  # Declare options
  options = {
    nixcosmic.hardened.accountsDaemon.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "NixcOSmic hardened systemd configuration for accounts-daemon.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.hardened.accountsDaemon.enable {
    systemd.services.accounts-daemon.serviceConfig = {
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectProc = "invisible";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      PrivateTmp = true;
      RestrictSUIDSGID = true;
      SystemCallFilter = [
        "~@swap"
        "~@resources"
        "~@raw-io"
        "~@mount"
        "~@module"
        "~@reboot"
        "~@debug"
        "~@cpu-emulation"
        "~@clock"
      ];
    };
  };
}
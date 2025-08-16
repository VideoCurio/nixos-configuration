{ config, lib, ... }:

{
  # Declare options
  options = {
    nixcosmic.hardened.acpid.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "NixcOSmic hardened systemd configuration for acpid.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.hardened.acpid.enable {
    systemd.services.acpid.serviceConfig = {
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectProc = "invisible";
      PrivateTmp = true;
      PrivateNetwork = true;
      PrivateMounts = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = [
        "~AF_INET6"
        "~AF_INET"
        "~AF_PACKET"
      ];
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      SystemCallFilter = [
        "~@mount"
        "~@swap"
        "~@obsolete"
        "~@cpu-emulation"
      ];
      SystemCallArchitectures = "native";
      CapabilityBoundingSet= [
        "~CAP_CHOWN"
        "~CAP_FSETID"
        "~CAP_SETFCAP"
      ];
    };
  };
}
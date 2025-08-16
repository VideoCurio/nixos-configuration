{ config, lib, ... }:

{
  # Declare options
  options = {
    nixcosmic.hardened.networkManager-dispatcher.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "NixcOSmic hardened systemd configuration for networkManager-dispatcher.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.hardened.networkManager-dispatcher.enable {
    systemd.services.NetworkManager-dispatcher.serviceConfig = {
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      ProtectProc = "invisible";
      PrivateTmp = true;
      PrivateMounts = true;
      RestrictRealtime = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_NETLINK"
        "AF_INET"
        "AF_INET6"
        "AF_PACKET"
      ];
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      SystemCallFilter = [
        "~@mount"
        "~@module"
        "~@swap"
        "~@obsolete"
        "~@cpu-emulation"
        "ptrace"
      ];
      SystemCallArchitectures = "native";
      LockPersonality= true;
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
    };
  };
}
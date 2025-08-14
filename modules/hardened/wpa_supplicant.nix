{
  systemd.services.wpa_supplicant.serviceConfig = {
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
      "~@raw-io"
      "~@privileged"
      "~@keyring"
      "~@reboot"
      "~@module"
      "~@swap"
      "~@resources"
      "~@obsolete"
      "~@cpu-emulation"
      "ptrace"
    ];
    SystemCallArchitectures = "native";
    LockPersonality= true;
    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  };
}
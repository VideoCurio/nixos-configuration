{
  systemd.services.NetworkManager.serviceConfig = {
    NoNewPrivileges = true;
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
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
  };
}
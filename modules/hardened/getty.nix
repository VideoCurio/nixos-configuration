{
  systemd.services."getty@".serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectClock = true;
    PrivateMounts = true;
    PrivateTmp = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
    ];
    RestrictNamespaces = true;
    SystemCallErrorNumber = "EPERM";
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "~@obsolete"
      "~@debug"
      "~@reboot"
      "~@swap"
      "~@clock"
      "~@cpu-emulation"
    ];
    LockPersonality = true;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];
    MemoryDenyWriteExecute = true;
    UMask = 0077;
  };
}
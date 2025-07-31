{
  systemd.services.rescue.serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "full";
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
    PrivateNetwork = true;
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
      "~@swap"
      "~@clock"
      "~@obsolete"
      "~@cpu-emulation"
      "~@resources"
    ];
    SystemCallArchitectures = "native";
    CapabilityBoundingSet= [
      "~CAP_CHOWN"
      "~CAP_FSETID"
      "~CAP_SETFCAP"
    ];
  };
}
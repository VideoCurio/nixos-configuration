{
  systemd.services.nscd.serviceConfig = {
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    RestrictNamespaces = true;
    RestrictRealtime = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    SystemCallFilter = [
      "~@mount"
      "~@swap"
      "~@clock"
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
}
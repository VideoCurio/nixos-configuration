{
  systemd.services.sshd.serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = "read-only";
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    DevicePolicy = "closed";
    SystemCallFilter = [
      "~@keyring"
      "~@swap"
      "~@clock"
      "~@module"
      "~@obsolete"
      "~@cpu-emulation"
    ];
    SystemCallArchitectures = "native";
  };
}
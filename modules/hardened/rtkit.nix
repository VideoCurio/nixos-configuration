{
  systemd.services.rtkit-daemon.serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [
      "~AF_INET6"
      "~AF_INET"
      "~AF_PACKET"
    ];
    MemoryDenyWriteExecute = true;
    DevicePolicy = "closed";
    LockPersonality = true;
    SystemCallFilter = [
      "~@keyring"
      "~@swap"
      "~@clock"
      "~@module"
      "~@obsolete"
      "~@cpu-emulation"
    ];
  };
}
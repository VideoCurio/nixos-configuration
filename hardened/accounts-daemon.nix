{
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
}
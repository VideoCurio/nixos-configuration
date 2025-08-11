# Must be imported by configuration.nix
# Laptop hardware related packages.

{ config, lib, pkgs, ... }:

{
  # TLP - Optimize Linux Laptop Battery Life
  # See: https://linrunner.de/tlp/
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="performance";
      CPU_SCALING_GOVERNOR_ON_AC="powersave";

      # Battery care - prevent the battery from charging fully to preserve lifetime.
      START_CHARGE_THRESH_BAT0=75;
      STOP_CHARGE_THRESH_BAT0=80;

      CPU_MAX_PERF_ON_AC=100;
      CPU_MAX_PERF_ON_BAT=60;
      CPU_BOOST_ON_AC=1;
      CPU_BOOST_ON_BAT=0;
    };
  };
}
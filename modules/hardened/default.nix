# Imports every other configurations files from here.

{ pkgs, lib, ... }:
{
  imports = [
    ./accounts-daemon.nix
    ./acpid.nix
    ./cups.nix
    ./dbus.nix
  ];
}

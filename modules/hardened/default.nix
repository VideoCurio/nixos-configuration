# Imports every other configurations files from here.

{ pkgs, lib, ... }:
{
  imports = [
    ./accounts-daemon.nix
    ./acipd.nix
    ./cups.nix
    ./dbus.nix
  ];
}

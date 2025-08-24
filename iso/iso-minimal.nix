# NixCOSMIC-minimal ISO configuration file
# Basic installer for the console. Based on NixOS installation-cd-minimal-combined.nix
# See: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
# https://nixos.org/manual/nixos/stable/index.html#sec-building-image

{ pkgs, modulesPath, lib, config, ... }:
let
  nixcosmic-install = pkgs.writeShellScriptBin "nixcosmic-install" ''
    #!/usr/bin/env bash

    set -eu

    printf "Hello world"
  '';
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-combined.nix"
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  # Enabling or disabling modules:

  # Minimum packages for installation
  environment.systemPackages = [
    nixcosmic-install
    pkgs.nano
    pkgs.parted
    pkgs.git
    pkgs.gnused
    pkgs.pciutils
  ];

  networking.hostName = "NixCOSMIC";
}


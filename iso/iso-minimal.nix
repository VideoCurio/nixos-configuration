# CuriOS-minimal ISO configuration file
# Basic installer for the console. Based on NixOS ${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix
# See: https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
# https://nixos.org/manual/nixos/stable/index.html#sec-building-image
# https://nixos.org/manual/nixpkgs/stable/#chap-stdenv

{ pkgs, modulesPath, ... }:
let
  curios-sources = pkgs.callPackage ../pkgs/curios-sources {};
  curios-dotfiles = pkgs.callPackage ../pkgs/curios-dotfiles {};
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
    #"${modulesPath}/installer/cd-dvd/installation-cd-minimal-combined.nix"
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  # Enabling or disabling modules:

  # Minimum packages for installation
  environment.systemPackages = [
    curios-sources
    curios-dotfiles
    pkgs.nano
    pkgs.parted
    pkgs.git
    pkgs.gnused
    pkgs.pciutils
  ];

  networking.hostName = "CuriOS";
}


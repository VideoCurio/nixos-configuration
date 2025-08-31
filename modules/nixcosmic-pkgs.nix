# Custom made packages for NixCOSMIC
{ pkgs, lib, ... }:
let
  nixcosmic-dotfiles = pkgs.callPackage ../pkgs/nixcosmic-dotfiles {};
  nixcosmic-release = pkgs.callPackage ../pkgs/nixcosmic-release {};
in {
  environment.systemPackages = [
    nixcosmic-dotfiles
    nixcosmic-release
  ];
}
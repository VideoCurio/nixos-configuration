# Custom made packages for NixCOSMIC
{ pkgs, lib, ... }:
let
  nixcosmic-dotfiles = pkgs.callPackage ../pkgs/nixcosmic-dotfiles {};
in {
  environment.systemPackages = [
    nixcosmic-dotfiles
  ];
}
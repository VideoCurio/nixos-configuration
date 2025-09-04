# Custom made packages for CuriOS
{ pkgs, lib, ... }:
let
  curios-dotfiles = pkgs.callPackage ../pkgs/curios-dotfiles {};
in {
  environment.systemPackages = [
    curios-dotfiles
  ];
}
{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ../pkgs/nixcosmic-sources {}
#pkgs.callPackage ../pkgs/nixcosmic-dotfiles {}

# test it locally with:
# nix-build && nix-env -i -f default.nix

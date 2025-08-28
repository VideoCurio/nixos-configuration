{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ../pkgs/nixcosmic-dotfiles {}
#pkgs.callPackage ../pkgs/nixcosmic-sources {}

# test it locally with:
# nix-build && nix-env -i -f default.nix

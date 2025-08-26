{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./nixcosmic-sources {}

# test it locally with:
# nix-build && nix-env -i -f default.nix

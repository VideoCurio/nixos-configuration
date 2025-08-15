# dotfiles installer from https://github.com/VideoCurio/nixos-dotfiles

{ config, lib, pkgs, ... }:
let
  dotfiles-installer = pkgs.writeShellScriptBin "dotfiles-installer" ''
    #!/usr/bin/env bash

    # This script install the dotfiles from https://github.com/VideoCurio/nixos-dotfiles
    # Made for Linux and a COSMIC desktop environment.
    # git required.

    set -eu

    printf "Installing VideoCurio dotfiles..."
  '';
in {
  # Declare options
  options = {
    nixcosmic.desktop.dotfiles.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "VideoCurio NixcOSmic dotfiles installer.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.dotfiles.enable {
    environment.systemPackages = [ dotfiles-installer ];
  };
}

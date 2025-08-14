# Various developer desktop apps.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.desktop.apps.devops.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Desktop apps for developers.";
    };
    nixcosmic.desktop.apps.devops.python313.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Python3.13 and JetBrains PyCharm Community.";
    };
    nixcosmic.desktop.apps.devops.rust.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Rust with cargo and JetBrains RustRover.";
    };
    nixcosmic.desktop.apps.devops.networks.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Nmap, Zenmap, wireshark, remina.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.apps.devops.enable {
    environment.systemPackages = with pkgs; [
      # Devops
      cloudflared
      # Python3
      python313Full
      python313Packages.pip
      python313Packages.docker
      python313Packages.setuptools
      python313Packages.cryptography
      jetbrains.pycharm-community
      # Rust
      rustup # provide cargo, rustc, rust-analyzer and more
      jetbrains.rust-rover
      # Networks
      nmap
      zenmap
      wireshark # should add user to wireshark group
      # VNC
      remmina
    ];
  };
}

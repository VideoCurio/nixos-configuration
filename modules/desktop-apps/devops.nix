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
    nixcosmic.desktop.apps.devops.python312.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Python3.12 and JetBrains PyCharm Community.";
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
      # VNC
      remmina
    ] ++
    (
      if (confg.nixcosmic.desktop.apps.devops.python312.enable == true)
        then [
          # Python3
          python312Full
          python312Packages.pip
          python312Packages.setuptools
          python312Packages.cryptography
          jetbrains.pycharm-community
        ]
      else []
    ) ++
    (
      if (confg.nixcosmic.desktop.apps.devops.rust.enable == true)
        then [
          # Rust
          rustup # provide cargo, rustc, rust-analyzer and more
          jetbrains.rust-rover
        ]
      else []
    ) ++
    (
      if (confg.nixcosmic.desktop.apps.devops.networks.enable == true)
        then [
          # Networks
          nmap
          zenmap
          wireshark # TODO: add user to wireshark group
        ]
      else []
    );
  };
}

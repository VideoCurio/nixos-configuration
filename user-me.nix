# System users should be defined here.
# Must be imported by configuration.nix

{ config, lib, pkgs, ... }:

let
  # Following variables can be edited.
  # Default user password. Change it later, after your first boot with COSMIC Parameters > System & Accounts
  # OR with the 'passwd' command line.
  # Do **NOT** set your real password HERE !
  password = "changeme"; # change it later
in {
  users.mutableUsers = true;
  # Define a user account
  users.users.me = { # Change 'me' to your username !!
    isNormalUser = true;
    initialPassword = password;
    description = "My Name"; # Change me !!
    extraGroups =  [
      "wheel"
      "audio"
      "sound"
      "video"
    ]
    ++ lib.optionals config.nixcosmic.networking.enable [
      "networkmanager"
    ]
    ++ lib.optionals config.nixcosmic.virtualisation.enable [
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "kvm"
      "input"
      "disk"
    ];
    useDefaultShell = true;
    # User SSH pubkey
    #openssh.authorizedKeys.keys = [ "ssh-ed25519 XXXXXXX me@me.com" ]; # Change me !!
  };

}

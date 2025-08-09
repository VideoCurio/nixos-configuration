# System users should be defined here.
# Must be imported by configuration.nix

{ config, lib, pkgs, ... }:

let
  # Following variables can be edited.
  # Default user password, change it after your first boot with COSMIC Parameters > System & Accounts
  # OR with 'passwd' command line.
  password = "changeme";
in {
  users.mutableUsers = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = { # Change me !!
    isNormalUser = true;
    initialPassword = password;
    description = "David B."; # Change me !!
    extraGroups = [ "networkmanager" "wheel" "audio" "sound" "video" ]; # Enable sudo for the user.
    useDefaultShell = true;
    # User SSH pubkey
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHkcdpx7N45SWb8RokTWnyPsKtMfvAki1TsxH3DhVI7 david@videocurio.com" ]; # Change me !!
  };

}

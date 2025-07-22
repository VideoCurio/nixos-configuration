# System users should be defined here.
# Must be imported by configuration.nix

{ config, lib, pkgs, ... }:

let
  # Following variables can be edited.
  password = "changeme"; # default user password, change it after your first boot with cosmic Parameters > System & Accounts or with passwd command line.
in {
  users.mutableUsers = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # CHANGE ME
  users.users.david = {
    isNormalUser = true;
    initialPassword = password;
    description = "David B.";
    extraGroups = [ "networkmanager" "wheel" "audio" "sound" "video" "docker" ]; # Enable ‘sudo’ for the user.
    useDefaultShell = true;
    # User SSH pubkey
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHkcdpx7N45SWb8RokTWnyPsKtMfvAki1TsxH3DhVI7 david@videocurio.com" ];
  };

}

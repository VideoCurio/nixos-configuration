# Must be imported by configuration.nix
# DevOPS packages for work.

{ config, lib, pkgs, ... }:

{
  # Virtualisation
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # Devops
    docker-buildx
    docker-compose
    python313Full
    python313Packages.pip
    python313Packages.docker
    jetbrains.pycharm-community
    nmap
    zenmap
    wireshark
  ];
}
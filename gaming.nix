# Must be imported by configuration.nix
# Gaming related packages.

{ config, lib, pkgs, ... }:

{
  # Steam
  nixpkgs.config.allowUnfree = lib.mkDefault true;
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    #localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # OBS
  programs.obs-studio = {
    enable = true;
  };

  # Various packages
  services.input-remapper = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    teamspeak6-client
    # Steam, set game property > launch option to "gamemoderun %command%" for Windows only games.
    # See: https://www.protondb.com/ for more launch options.
    gamemode
    steam-run
  ];
}

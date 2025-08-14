# Gaming related packages.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.desktop.apps.gaming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop apps for gaming: Steam, gamemoderun, Teamspeak6, input-remapper.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.desktop.apps.gaming.enable {
    # Steam
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    programs.steam = {
      enable = true;
      #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      #localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # Various packages
    services.input-remapper = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      teamspeak6-client
      # Steam, set game property > launch option to "gamemoderun %command%" for Windows only games.
      # See: https://www.protondb.com/ for more launch options.
      # See: https://github.com/FeralInteractive/gamemode
      gamemode
      steam-run
    ];
  };
}

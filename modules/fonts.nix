# Fonts

{ config, lib, pkgs, ... }:
{
  # Declare options
  options = {
    nixcosmic.fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add essentials fonts.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.fonts.enable {
    # See command: 'fc-list'
    fonts = {
      fontconfig.enable = true;
      fontconfig.useEmbeddedBitmaps = true;
      fontDir.enable = true;
      packages = with pkgs; [
        dejavu_fonts
        fira
        font-awesome
        jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        open-sans
      ];
    };
  };
}
# Must be imported by configuration.nix
# AI tools packages.

{ config, lib, pkgs, ... }:

{
  # Ollama, see: https://wiki.nixos.org/wiki/Ollama
  # For a ZSH integration, see: https://github.com/VideoCurio/MyZSH
  services.ollama = {
    enable = true;
    # Optional: preload models, see https://ollama.com/library
    # or use `ollama pull <model-name>`
    #loadModels = [ "mistral-nemo:latest" ];
    # GPU accel
    acceleration = "rocm"; # "false": 100% CPU,"nvidia": modern Nvidia GPU ,"rocm": modern AMD GPU
  };
}
# Must be imported by configuration.nix
# AI tools packages.

{ config, lib, pkgs, ... }:

{
  # Ollama, see: https://wiki.nixos.org/wiki/Ollama
  # For a ZSH integration, see: https://github.com/VideoCurio/MyZSH
  services.ollama = {
    enable = true;
    #home = "/home/ollama";
    # Optional: preload models, see https://ollama.com/library
    # or use `ollama pull <model-name>`
    #loadModels = [ "mistral-nemo:latest" ];
    # GPU accel
    acceleration = "rocm"; # "false": 100% CPU,"nvidia": modern Nvidia GPU ,"rocm": modern AMD GPU
    # For AMD Ryzen 7 PRO hardware
    # nix-shell -p "rocmPackages.rocminfo" --run "rocminfo" | grep "gfx"
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1103"; # used to be necessary, but doesn't seem to anymore
    };
    rocmOverrideGfx = "11.0.2";
  };
  # Open WebUI, see: https://docs.openwebui.com/
  services.open-webui = {
    enable = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
  };
}
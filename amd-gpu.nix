# Add AMD GPU configuration
# Must be imported by configuration.nix
# See: https://nixos.wiki/wiki/AMD_GPU

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    # Ban CPU integrated GPU
    #blacklistedKernelModules = [ "i915" ];
  };

  # AMD GPU
  hardware = {
    graphics = {
      # Enable OpenGL
      enable = lib.mkDefault true;
      #enable32Bit = lib.mkDefault true;
    };
    amdgpu = {
      # Enable Vulkan
      amdvlk.enable = lib.mkDefault true;
      #amdvlk.support32Bit.enable = lib.mkDefault true;
    };
  };

  # Load driver for Xorg and Wayland
  services.xserver.enable = lib.mkDefault true;
  services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];

  # GUI AMD GPU controller + RadeonTOP
  environment.systemPackages = with pkgs; [
    lact
    radeontop
    #btop-rocm # btop with GPU, REMOVE btop from configuration.nix !
  ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
}

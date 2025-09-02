# Custom settings goes here.
# Could be edited - This file will NOT be modified by update script later.
# Must be imported by configuration.nix
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# See: https://nixos.org/manual/nixos/stable/
# man configuration.nix

{ config, lib, pkgs, ... }:
{
  ### NixCOSMIC options settings goes here:
  nixcosmic.system.hostname = "NixCOSMIC";
  nixcosmic.system.i18n.locale = "en_US.UTF-8";
  nixcosmic.system.keyMap = "us";
  nixcosmic.system.timeZone = "Europe/Paris";

  ### Activate or deactivate NixCOSMIC modules/ from here:
  nixcosmic.desktop.apps.basics.enable = lib.mkDefault true; # Brave browser, Alacritty, Bitwarden, Signal, Yubico auth, Gimp3, EasyEffects, ProtonVPN gui.
  nixcosmic.desktop.apps.devops.enable = lib.mkDefault false; # Required by apps.devops options below. + Cloudlfared
  nixcosmic.desktop.apps.devops.networks.enable = lib.mkDefault false; # Nmap, Zenmap, Wireshark
  nixcosmic.desktop.apps.devops.python312.enable = lib.mkDefault false; # Python3.12, pip, setuptools, JetBrains PyCharm-Community
  nixcosmic.desktop.apps.devops.rust.enable = lib.mkDefault false; # Rustc, cargo, rust-analyzer, clippy + more, JetBrains RustRover
  nixcosmic.desktop.apps.gaming.enable = lib.mkDefault false; # Steam, Heroic Launcher, gamemoderun, Input-Remapper, TeamSpeak6 client
  nixcosmic.desktop.apps.studio.enable = lib.mkDefault false; # OBS, Audacity, DaVinci Resolve

  nixcosmic.hardware.laptop.enable = lib.mkDefault false; # EXPERIMENTAL - laptop battery saver
  nixcosmic.networking.enable = lib.mkDefault true; # NetworkManager (required by COSMIC).
  nixcosmic.services.enable = lib.mkDefault true; # Flatpak + flathub/cosmic repos, pipewire
  nixcosmic.services.printing.enable = lib.mkDefault false; # CUPS
  nixcosmic.services.sshd.enable = lib.mkDefault false; # SSH daemon
  nixcosmic.services.ai.enable = lib.mkDefault false; # Ollama with mistral-nemo, open-webui
  nixcosmic.virtualisation.enable = lib.mkDefault false; # docker, docker buildx, docker-compose, QEMU/KVM, libvirt, virt-manager
  nixcosmic.virtualisation.wine.enable = lib.mkDefault false; # Wine 32 and 64 bits with Wayland support.

  # Hardened configurations -WIP-
  # Activate and test one by one - may break some programs
  # Check results with: `systemd-analyze security`
  nixcosmic.hardened.accountsDaemon.enable = lib.mkDefault false;
  nixcosmic.hardened.acpid.enable = lib.mkDefault false;
  nixcosmic.hardened.cups.enable = lib.mkDefault false;
  nixcosmic.hardened.dbus.enable = lib.mkDefault false;
  nixcosmic.hardened.display-manager.enable = lib.mkDefault false;
  nixcosmic.hardened.docker.enable = lib.mkDefault false;
  nixcosmic.hardened.getty.enable = lib.mkDefault false; # WARNING: will prevent TTY console login
  nixcosmic.hardened.networkManager.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  nixcosmic.hardened.networkManager-dispatcher.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  nixcosmic.hardened.nix-daemon.enable = lib.mkDefault false;
  nixcosmic.hardened.nscd.enable = lib.mkDefault false;
  nixcosmic.hardened.rescue.enable = lib.mkDefault false;
  nixcosmic.hardened.rtkit-daemon.enable = lib.mkDefault false;
  nixcosmic.hardened.sshd.enable = lib.mkDefault false;
  nixcosmic.hardened.user.enable = lib.mkDefault false; # TODO: 'Flatpak run' bug if set to true
  nixcosmic.hardened.wpa_supplicant.enable = lib.mkDefault false;

  ### NixOS packages
  environment.systemPackages = with pkgs; [
    # Add your packages here:
  ];

  ### Change user settings here:
  users.users.nixos = {
    description = "Me";
    #openssh.authorizedKeys.keys = [ "ssh-ed25519 XXXXXXX me@me.com" ];  # Set your SSH pubkey here
  };

  ### Change general settings here:
  # networking
  networking = {
    nameservers = [ "9.9.9.9" "1.1.1.1" "2620:fe::fe" "2620:fe::9" ]; # Quad9 and cloudflare DNS servers.
    # Use DHCP to get an IP address:
    useDHCP = lib.mkDefault true;
    # Open ports in the firewall.
    #firewall.allowedTCPPorts = [ ... ];
    #firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    #firewall.enable = false;

    # Configure network proxy if necessary
    #proxy = {
    #  default = "http://user:password@proxy:port/";
    #  noProxy = "127.0.0.1,localhost,internal.domain";
    #};
  };
  # pipewire sound settings:
  services.pipewire = {
    extraConfig.pipewire."92-low-latency" = {
      "default.clock.quantum" = 512; # Keep increasing the quant value until you get no sound crackles
      "default.clock.min-quantum" = 256;
      "default.clock.max-quantum" = 16384;
    };
  };
  # Ollama
  services.ollama = {
    # For AMD Ryzen 7 PRO hardware, uncomment lines below.
    # To adjust value, see command result of: nix-shell -p "rocmPackages.rocminfo" --run "rocminfo" | grep "gfx"
    #environmentVariables = {
    #  HCC_AMDGPU_TARGET = "gfx1103"; # used to be necessary, but doesn't seem to anymore
    #};
    #rocmOverrideGfx = "11.0.2";
  };
}
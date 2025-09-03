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
  nixcosmic = {
    system = {
      hostname = "NixCOSMIC";
      i18n.locale = "en_US.UTF-8";
      keyMap = "us";
      timeZone = "Europe/Paris";
    };
    ### Activate or deactivate NixCOSMIC modules/ from here:
    desktop.apps = {
      basics.enable = true; # Brave browser, Alacritty, Bitwarden, Signal, Yubico auth, Gimp3, EasyEffects, ProtonVPN gui.
      devops = {
        enable = false; # Required by desktop.apps.devops options below. + Cloudlfared
        networks.enable = false; # Nmap, Zenmap, Wireshark
        go.enable = false; # Go, gofmt, JetBrains GoLand
        python312.enable = false; # Python3.12, pip, setuptools, JetBrains PyCharm-Community
        rust.enable = false; # Rustc, cargo, rust-analyzer, clippy + more, JetBrains RustRover
      };
      gaming.enable = false; # Steam, Heroic Launcher, gamemoderun, Input-Remapper, TeamSpeak6 client
      studio.enable = false; # OBS, Audacity, DaVinci Resolve
    };
    hardware.laptop.enable = false; # EXPERIMENTAL - laptop battery saver
    networking.enable = true; # NetworkManager (required by COSMIC).
    services = {
      enable = true; # Flatpak + flathub/cosmic repos, pipewire
      printing.enable = false; # CUPS
      sshd.enable = false; # SSH daemon
      ai.enable = false; # Ollama with mistral-nemo, open-webui
    };
    virtualisation = {
      enable = false; # docker, docker buildx, docker-compose, QEMU/KVM, libvirt, virt-manager
      wine.enable = false; # Wine 32 and 64 bits with Wayland support.
    };
    hardened = {
      # Hardened configurations -WIP-
      # Activate and test one by one - may break some programs
      # Check results with: `systemd-analyze security`
      accountsDaemon.enable = false;
      acpid.enable = false;
      cups.enable = false;
      dbus.enable = false;
      display-manager.enable = false;
      docker.enable = false;
      getty.enable = false; # WARNING: will prevent TTY console login
      networkManager.enable = false; # TODO: proton-vpn bug if set to true
      networkManager-dispatcher.enable = false; # TODO: proton-vpn bug if set to true
      nix-daemon.enable = false;
      nscd.enable = false;
      rescue.enable = false;
      rtkit-daemon.enable = false;
      sshd.enable = false;
      user.enable = false; # TODO: 'Flatpak run' bug if set to true
      wpa_supplicant.enable = false;
    };
  };

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
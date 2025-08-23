# NixC*OS*MIC modules

```bash
  # Platform
  nixcosmic.platform.amd64.enable = lib.mkDefault true;
  nixcosmic.platform.rpi4.enable = lib.mkDefault false;

  # Enabling or disabling ./modules here:
  nixcosmic.hardware.amdGpu.enable = lib.mkDefault false; # Modern AMD GPU
  nixcosmic.hardware.nvidiaGpu.enable = lib.mkDefault false; # Modern Nvidia GPU
  nixcosmic.hardware.laptop.enable = lib.mkDefault false; # EXPERIMENTAL - laptop battery saver

  # updated by ./install-system.sh - do NOT edit.
  nixcosmic.filesystems.luks.enable = lib.mkDefault true;
  nixcosmic.filesystems.minimal.enable = lib.mkDefault false;

  nixcosmic.bootefi.enable = lib.mkDefault true;
  nixcosmic.desktop.cosmic.enable = lib.mkDefault true; # COSMIC desktop environment
  nixcosmic.desktop.dotfiles.enable = lib.mkDefault true; # Custom Nixos+COSMIC dotfiles by VideoCurio

  nixcosmic.desktop.apps.basics.enable = lib.mkDefault true; # Brave browser, Alacritty, Bitwarden, Signal, Yubico auth, Gimp3, EasyEffects, ProtonVPN gui.
  nixcosmic.desktop.apps.devops.enable = lib.mkDefault false; # Required for apps.devops options below. + Cloudlfared
  nixcosmic.desktop.apps.devops.networks.enable = lib.mkDefault false; # Nmap, Zenmap, Wireshark
  nixcosmic.desktop.apps.devops.python312.enable = lib.mkDefault false; # Python3.12, pip, setuptools, JetBrains PyCharm-Community
  nixcosmic.desktop.apps.devops.rust.enable = lib.mkDefault false; # Rustc, cargo, rust-analyzer, clippy + more, JetBrains RustRover
  nixcosmic.desktop.apps.gaming.enable = lib.mkDefault false; # Steam, Heroic Launcher, gamemoderun, Input-Remapper, TeamSpeak6 client
  nixcosmic.desktop.apps.studio.enable = lib.mkDefault false; # OBS, Audacity, DaVinci Resolve

  nixcosmic.fonts.enable = lib.mkDefault true; # Fira, Noto, some Nerds fonts, JetBrains Mono
  nixcosmic.networking.enable = lib.mkDefault true; # NetworkManager, DNS set to Quad9 and cloudflare.
  nixcosmic.services.enable = lib.mkDefault true; # Flatpak + flathub/cosmic repos, pipewire
  nixcosmic.services.printing.enable = lib.mkDefault false; # CUPS
  nixcosmic.services.sshd.enable = lib.mkDefault true; # SSH daemon
  nixcosmic.services.ai.enable = lib.mkDefault false; # Ollama with mistral-nemo, open-webui
  nixcosmic.shell.zsh.enable = lib.mkDefault true; # ZSH shell, REQUIRED for nixcosmic.desktop.dotfiles.enable
  nixcosmic.virtualisation.enable = lib.mkDefault false; # docker, docker buildx, docker-compose, QEMU/KVM, libvirt, virt-manager
  nixcosmic.virtualisation.wine.enable = lib.mkDefault false; # Wine 32 and 64 bits with Wayland support.

  # Test hardened configurations one by one
  # Check results with: `systemd-analyze security`
  nixcosmic.hardened.accountsDaemon.enable = lib.mkDefault true;
  nixcosmic.hardened.acpid.enable = lib.mkDefault true;
  nixcosmic.hardened.cups.enable = lib.mkDefault false;
  nixcosmic.hardened.dbus.enable = lib.mkDefault true;
  nixcosmic.hardened.display-manager.enable = lib.mkDefault false;
  nixcosmic.hardened.docker.enable = lib.mkDefault false;
  nixcosmic.hardened.getty.enable = lib.mkDefault true;
  nixcosmic.hardened.networkManager.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  nixcosmic.hardened.networkManager-dispatcher.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  nixcosmic.hardened.nix-daemon.enable = lib.mkDefault true;
  nixcosmic.hardened.nscd.enable = lib.mkDefault true;
  nixcosmic.hardened.rescue.enable = lib.mkDefault true;
  nixcosmic.hardened.rtkit-daemon.enable = lib.mkDefault true;
  nixcosmic.hardened.sshd.enable = lib.mkDefault true;
  nixcosmic.hardened.user.enable = lib.mkDefault false; # TODO: 'Flatpak run' bug if set to true
  nixcosmic.hardened.wpa_supplicant.enable = lib.mkDefault true;
```

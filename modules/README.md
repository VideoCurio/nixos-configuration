# Curi*OS* modules

```bash
  # updated by curios-install during ISO install
  curios.platform.amd64.enable = lib.mkDefault true;
  curios.platform.rpi4.enable = lib.mkDefault false;

  ######## Enabling or disabling ./modules here:
  # Modern AMD GPU
  # updated by curios-install during ISO install
  curios.hardware.amdGpu.enable = lib.mkDefault false;
  # Modern Nvidia GPU
  # updated by curios-install during ISO install
  curios.hardware.nvidiaGpu.enable = lib.mkDefault false;
  # EXPERIMENTAL - laptop battery saver
  curios.hardware.laptop.enable = lib.mkDefault false;

  # updated by curios-install during ISO install
  curios.filesystems.luks.enable = lib.mkDefault true;
  curios.filesystems.minimal.enable = lib.mkDefault false;

  curios.bootefi.enable = lib.mkDefault true;
  curios.desktop.cosmic.enable = lib.mkDefault true; # COSMIC desktop environment

  curios.desktop.apps.basics.enable = lib.mkDefault true; # Brave browser, Alacritty, Bitwarden, Signal, Yubico auth, Gimp3, EasyEffects, ProtonVPN gui.
  curios.desktop.apps.devops.enable = lib.mkDefault false; # Required for apps.devops options below. + Cloudlfared
  curios.desktop.apps.devops.networks.enable = lib.mkDefault false; # Nmap, Zenmap, Wireshark
  curios.desktop.apps.devops.python312.enable = lib.mkDefault false; # Python3.12, pip, setuptools, JetBrains PyCharm-Community
  curios.desktop.apps.devops.rust.enable = lib.mkDefault false; # Rustc, cargo, rust-analyzer, clippy + more, JetBrains RustRover
  curios.desktop.apps.gaming.enable = lib.mkDefault false; # Steam, Heroic Launcher, gamemoderun, Input-Remapper, TeamSpeak6 client
  curios.desktop.apps.studio.enable = lib.mkDefault false; # OBS, Audacity, DaVinci Resolve

  curios.fonts.enable = lib.mkDefault true; # Fira, Noto, some Nerds fonts, JetBrains Mono
  curios.networking.enable = lib.mkDefault true; # NetworkManager, DNS set to Quad9 and cloudflare.
  curios.services.enable = lib.mkDefault true; # Flatpak + flathub/cosmic repos, pipewire
  curios.services.printing.enable = lib.mkDefault false; # CUPS
  curios.services.sshd.enable = lib.mkDefault false; # SSH daemon
  curios.services.ai.enable = lib.mkDefault false; # Ollama with mistral-nemo, open-webui
  curios.shell.zsh.enable = lib.mkDefault true; # ZSH shell, REQUIRED
  curios.virtualisation.enable = lib.mkDefault false; # docker, docker buildx, docker-compose, QEMU/KVM, libvirt, virt-manager
  curios.virtualisation.wine.enable = lib.mkDefault false; # Wine 32 and 64 bits with Wayland support.

  # Test hardened configurations one by one
  # Check results with: `systemd-analyze security`
  curios.hardened.accountsDaemon.enable = lib.mkDefault false;
  curios.hardened.acpid.enable = lib.mkDefault false;
  curios.hardened.cups.enable = lib.mkDefault (
    config.curios.services.printing.enable
  );
  curios.hardened.dbus.enable = lib.mkDefault false;
  curios.hardened.display-manager.enable = lib.mkDefault false;
  curios.hardened.docker.enable = lib.mkDefault false;
  curios.hardened.getty.enable = lib.mkDefault false; # WARNING: will prevent TTY console login
  curios.hardened.networkManager.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  curios.hardened.networkManager-dispatcher.enable = lib.mkDefault false; # TODO: proton-vpn bug if set to true
  curios.hardened.nix-daemon.enable = lib.mkDefault false;
  curios.hardened.nscd.enable = lib.mkDefault false;
  curios.hardened.rescue.enable = lib.mkDefault false;
  curios.hardened.rtkit-daemon.enable = lib.mkDefault false;
  curios.hardened.sshd.enable = lib.mkDefault (
    config.curios.services.sshd.enable
  );
  curios.hardened.user.enable = lib.mkDefault false; # TODO: 'Flatpak run' bug if set to true
  curios.hardened.wpa_supplicant.enable = lib.mkDefault false;
```

[![NixOS Unstable](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# NixOS + COSMIC = NixC*OS*MIC

This is my NixOS installer scripts and its configuration files. The desktop environment is [COSMIC](https://system76.com/cosmic/).
![NixOS COSMIC screenshot](https://github.com/VideoCurio/nixos-configuration/blob/master/img/Screenshot6.png?raw=true "NixOS with COSMIC DE")

------

|               | Packages     | Shortcut          |
|---------------|--------------|-------------------|
| **Desktop:**  | COSMIC       |                   |
| **Shell:**    | zsh          |                   |
| **Display:**  | Wayland      |                   |
| **Terminal:** | Alacritty    | Super + T         |
| **Launcher:** | pop-launcher | Super / Super + A |
| **Browser:**  | Brave        | Super + B         |

-----

> [!IMPORTANT]
> **Disclaimer:** This is a work in progress for a NixOS install and a Desktop Environment (COSMIC) still in Alpha stage.
> You should be familiar with [NixOS manual](https://nixos.org/manual/nixos/stable/) and [NixOS Wiki](https://nixos.wiki/wiki/Main_Page), for NixOS related questions go to [NixOS discourse](https://discourse.nixos.org/).

## Quick start

1. Get a NixOS 25.05+ Minimal ISO image:
   ```bash
   wget https://channels.nixos.org/nixos-25.05/latest-nixos-minimal-x86_64-linux.iso
   ```

2. Burn it on a USB stick with [Balena Etcher](https://etcher.balena.io/#download-etcher), [caligula](https://github.com/ifd3f/caligula) or the command `dd`.
   ```bash
   sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/sdb bs=10MB oflag=dsync status=progress
   ```
   Replace `/dev/sdb` with the path of the USB card (see command `sudo fdisk -l`).
3. Boot your machine on the USB stick. An internet connection is *REQUIRED* to perform the installation !
4. You should see a TTY command line as `nixos` user, switch to root user:
   ```bash
   sudo -i
   ```
5. (**OPTIONAL**) Switch keymap on non-us keyboard: 
   ```bash
   loadkeys fr
   ```
6. Download this git repository: 
   ```bash
   git clone https://github.com/VideoCurio/nixos-configuration.git
   cd nixos-configuration/
   ```
7. Edit `configuration.nix` now if you think you will need to activate one of the [modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) during the installation process.
   ```bash
   # Edit only if necessary:
   nano configuration.nix
   # Use Ctrl+s to save and Ctrl+x to exit nano
   ```
   **_Tip_**: Do not activate all modules during the installation phase. You can later edit the '/etc/nixos/configuration.nix' file.

8. Run the installer with the **recommended** options: `./install-system.sh --crypt /dev/nvme0n1`:
   > [!WARNING]
   > This script will **FORMAT** your disk !!! Backup your data before.
   ```bash
   # To find your disk /dev path:
   fdisk -l
   # For a full encrypted disk (LUKS + LVM) with a root partition of 100Go, on your first SSD:
   ./install-system.sh --crypt --root-size:100G /dev/nvme0n1
   # Answer questions asked by the script to complete the installation:
   Choose your language in the list below:
   1) en_US.UTF8
   2) fr_FR.UTF8
   3) es_ES.UTF8
   4) de_DE.UTF8
   5) zh_CN.UTF8
   6) ...
   Enter your choice (1-20): 2
   Choose your time zone (Europe/Paris):
   Choose your username : nixos
   Choose your machine hostname (NixCOSMIC): EVAUnit02
   ...
   
   # See --help option for more details:
   ./install-system.sh --help
   ```
9. If everything went according to plan, reboot.
   ```bash
   reboot now
   ```
10. **Enjoy!** User temporary password is "changeme".
    You can now change it, within COSMIC desktop: click on top right power button, then Parameters > System & Accounts > Users > "Your Account Name" > Change password.
    Or use the command `passwd` in a terminal.

-----

## Features

* Hardware configuration files for AMD, Intel and Raspberry Pi 4 platform. GPU configuration files for AMD and Nvidia hardware.
* Filesystem configuration for full encrypted disk (LUKS+LVM).
* COSMIC, a wayland desktop environment / windows manager by [System76](https://system76.com/cosmic/).
* Pop_launcher, launch or switch to every application just with the Super key. Forget about your mouse, use Super key combinations for everything.
* Flatpak with auto-update. COSMIC and Flathub repos pre-installed.
* Alacritty terminal with ZSH and a lot of good modern commands. [my nixos-dotfiles](https://github.com/VideoCurio/nixos-dotfiles) is pre-installed.
* Modular configuration files for apps like Ollama AI, docker, QEMU + virt-manager, python3, Rust and more...
* Modular hardened systemd services configurations files. WIP
* A bunch of nerd fonts...

Useful COSMIC shortcuts:

| **Action**                  | Shortcut                           |
|-----------------------------|------------------------------------|
| Application launcher/switch | Super                              |
| Change application focus    | Super + Up/Down/Left/Right         |
| Switch desktop              | Ctrl + Super + Up/Down             |
| Move application (tiles)    | Shift + Super + Up/Down/Left/Right |
| Launch web browser          | Super + B                          |
| Launch File manager         | Super + F                          |
| Launch a terminal           | Super + T                          |
| Applications menu           | Super + A                          |

### Dotfiles

[my nixos-dotfiles](https://github.com/VideoCurio/nixos-dotfiles) come pre-installed with my COSMIC theme (WIP) and for a nice Alacritty and ZSH integration.

-----

## NixC*OS*MIC management

Activate or deactivate [modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) to suit your needs and computer's hardware. [Modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) configuration start with 'nixcosmic.'.

For example: to activate an Nvidia GPU pilots set: `nixcosmic.hardware.nvidiaGpu.enable = lib.mkDefault true;` into '/etc/nixos/configuration.nix' file.
Want to game ? Set `nixcosmic.desktop.apps.gaming.enable` to true.
```bash
# Edit only if necessary:
nano /etc/nixos/configuration.nix
# Use Ctrl+s to save and Ctrl+x to exit nano
```
followed by:
```bash
sudo nixos-rebuild switch
```
To find more packages or options configuration, see [NixOS packages](https://search.nixos.org/packages?channel=25.05&size=50&sort=relevance&type=packages).

## NixOS management

NixOS is a Linux distribution based on the Nix package manager and build system. It supports reproducible and declarative system-wide configuration management as well as atomic upgrades and rollbacks, although it can additionally support imperative package and user management. In NixOS, all components of the distribution — including the kernel, installed packages and system configuration files — are built by Nix from pure functions called Nix expressions.
See [NixOS manual](https://nixos.org/manual/nixos/stable/) to learn more.

The default 'configuration.nix' is set to auto upgrade every night at 03:40 or on your first boot of the day, see `systemctl list-timers`.

Generations older than 7 days are automatically garbage collected. You can also manually do this with:
```bash
sudo nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild switch --upgrade && sudo nixos-rebuild list-generations
```
Watch your root directories size with:
```bash
dufw
# or
sudo du -sh /* 2>/dev/null | sort -rh
```

-----

## Developers notes
Developers should try theirs code against the `testing` branch.
```bash
git clone -b testing https://github.com/VideoCurio/nixos-configuration.git
```
Pull Request are welcomed.

-----

## License

Copyright (C) 2025  David BASTIEN

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Sources
[Cosmic desktop](https://github.com/pop-os/cosmic-epoch) by system76.
Hardened configuration files by [wallago](https://github.com/wallago/nix-system-services-hardened).

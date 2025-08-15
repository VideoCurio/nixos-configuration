[![NixOS Unstable](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# NixOS + COSMIC

This is my NixOS installer scripts and its configuration files. The desktop environment is [COSMIC](https://system76.com/cosmic/).
![NixOS COSMIC screenshot](https://github.com/VideoCurio/nixos-configuration/blob/master/img/Screenshot6.png?raw=true "NixOS with COSMIC DE")

------

|               | Packages     | Shortcut  |
|---------------|--------------|-----------|
| **Desktop:**  | COSMIC       |           |
| **Shell:**    | zsh          |           |
| **Display:**  | Wayland      |           |
| **Terminal:** | Alacritty    | Super + T |
| **Launcher:** | pop-launcher | Super     |
| **Browser:**  | Brave        | Super + B |

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
5. (OPTIONAL) Switch keymap on non-us keyboard: 
   ```bash
   loadkeys fr
   ```
6. Download this git repository: 
   ```bash
   git clone https://github.com/VideoCurio/nixos-configuration
   cd nixos-configuration/
   ```
7. Edit `configuration.nix` and `user-me.nix` files. Default `configuration.nix` file is for an Intel x86 platform with a full encrypted disk (LUKS).
   Change the `imports` section of the file to suit your needs and computer's hardware.
> [!IMPORTANT]
> You MUST edit the configuration.nix file to match your hardware and packages need. The script in step 8 does not detect hardware (yet) !
   ```bash
   # Edit imports part to match your hardware and environment.systemPackages to add/remove packages.
   # Edit all settings marked with 'Change me' comment.
   nano configuration.nix
   # Edit default user, change your name and your SSH pubkey:
   nano user-me.nix
   # Use Ctrl+s to save and Ctrl+x to exit nano
   ```
   **_Tip_**: If your hardware is not listed here, try the command `nixos-generate-config --root /mnt` as root, check the '/mnt/etc/nixos/hardware-configuration.nix' generate and remove the 'fileSystems' parts.

> [!WARNING]
> This script will **FORMAT** your disk !!! Backup your data before.
8. Run the installer `./install-system.sh`:
   ```bash
   # See fdisk command to list your disk:
   fdisk -l
   # For a full encrypted disk (LUKS + LVM) on your first SSD:
   ./install-system.sh --crypt /dev/nvme0n1
   # OR for a simple disk partition on the first HDD:
   ./install-system.sh /dev/sda
   # See --help option for more details:
   ./install-system.sh -h
   ```
9. If everything went according to plan, reboot.
   ```bash
   reboot now
   ```
10. **Enjoy!** User temporary default password is "changeme". Do **NOT** set your password in `user-me.nix`, instead log-in with the temporary password and use the command:
    ```bash
    passwd
    ```
    Or within COSMIC desktop: click on top right power button, then Parameters > System & Accounts > Users > "Your Account Name" > Change password

## Features

* Hardware configuration files for AMD, Intel, QEMU/KVM and Raspberry Pi 4 platform. GPU configuration files for AMD and Nvidia hardware.
* Filesystem configuration for full encrypted disk (LUKS+LVM).
* COSMIC, a wayland desktop environment / windows manager by [System76](https://system76.com/cosmic/).
* Pop_launcher, launch or switch to every application just with the Super key.
* Flatpak with auto-update. COSMIC and Flathub repos pre-installed.
* Alacritty terminal with ZSH and a lot of good modern commands. Finish to set up everything with [my nixos-dotfiles](https://github.com/VideoCurio/nixos-dotfiles).
* More nice applications in `*-tools.nix` files like Ollama AI, docker, QEMU + virt-manager, python3, Rust and more...
* Hardened systemd services configurations files. WIP
* A bunch of nerd fonts...

## Dotfiles

Want a nice Terminal with some cool plugins ? See [my nixos-dotfiles](https://github.com/VideoCurio/nixos-dotfiles).

## NixOS management

NixOS is a Linux distribution based on the Nix package manager and build system. It supports reproducible and declarative system-wide configuration management as well as atomic upgrades and rollbacks, although it can additionally support imperative package and user management. In NixOS, all components of the distribution — including the kernel, installed packages and system configuration files — are built by Nix from pure functions called Nix expressions.
See [NixOS manual](https://nixos.org/manual/nixos/stable/) to learn more.

If you want to modify your current configuration or add packages, edit the 'configuration.nix' file and rebuild it:
```bash
sudo nano /etc/nixos/configuration.nix
```
followed by:
```bash
sudo nixos-rebuild switch
```
To find packages or options configuration, see [NixOS packages](https://search.nixos.org/packages?channel=25.05&size=50&sort=relevance&type=packages).

This configuration is set to auto upgrade every night at 03:40, see `systemctl list-timers`.

Generations older than 7 days are automatically garbage collected. You can also manually do this with:
```bash
sudo nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild switch --upgrade && sudo nixos-rebuild list-generations
```
Watch your root directories size with:
```bash
sudo dust /
# or
duf
# or
sudo du -sh /* 2>/dev/null | sort -rh
```

## Developers notes
Developers should try theirs code against the `testing` branch.
```bash
git clone -b testing https://github.com/VideoCurio/nixos-configuration.git
```
Pull Request are welcomed.

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

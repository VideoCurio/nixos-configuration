[![NixOS Unstable](https://img.shields.io/badge/NixOS-25.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

# NixOS + COSMIC = Curi*OS*

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

1. Get the latest Curi*OS* 25.05 Minimal ISO image:
   ```bash
   wget --content-disposition https://github.com/VideoCurio/nixos-configuration/releases/download/25.05.0-rc3/curios-minimal_25.05.0-rc3_amd64-intel.iso
   ```
   Download and check iso signature:
   ```bash
   wget --content-disposition https://github.com/VideoCurio/nixos-configuration/releases/download/25.05.0-rc3/curios-minimal_25.05.0-rc3_amd64-intel.iso.sha256
   sha256sum --check curios-minimal_*.iso.sha256
   ```
   Must respond "Success".

2. Burn it on a USB stick with [Balena Etcher](https://etcher.balena.io/#download-etcher), [caligula](https://github.com/ifd3f/caligula) or the command `dd`.
   ```bash
   # Good old dd:
   sudo dd if=curios-minimal_25.05.0-rc3_amd64-intel.iso of=/dev/sdb bs=10MB oflag=dsync status=progress
   # or shiny caligula:
   caligula burn -s $(cat ./curios-minimal_25.05.0-rc3_amd64-intel.iso.sha256)
   ```
   Replace `/dev/sdb` with the path of the USB card (see command `sudo fdisk -l`).
3. Boot your machine on the USB stick (F8 or F12 key on startup, see your motherboard manufacturer's instructions). An internet connection is *REQUIRED* to perform the installation !
4. You should see a TTY command line as `nixos` user, switch to root user:
   ```bash
   sudo -i
   ```
5. (**OPTIONAL**) Switch keymap on non-us keyboard: 
   ```bash
   loadkeys fr
   ```
6. Run the installer with the **recommended** options: `curios-install --crypt --root-size 80G /dev/nvme0n1`:
> [!WARNING]
> This script will **FORMAT** your disk !!! Backup your data before.
   ```bash
   # To find your disk /dev path:
   fdisk -l
   # For a full encrypted disk (LUKS + LVM) and a root partition of 120Go, on your first SSD:
   curios-install --crypt --root-size 120G /dev/nvme0n1
   # Answer questions asked by the script to complete the installation:
   Choose your language in the list below:
   1) en_US.UTF8
   2) en_GB.UTF8
   3) fr_FR.UTF8
   4) es_ES.UTF8
   5) de_DE.UTF8
   6) zh_CN.UTF8
   7) ...
   Enter your choice (1-20): 3
   Choose your time zone (Europe/Paris):
   Choose your username: nixos
   Choose your machine hostname (curios): EVAUnit02
   AMD GPU detected, would like to install it ? (y/n): y
   Enabling AMD GPU...
   Partitioning disk /dev/nvme0n1 ? All data will be ERASED (y/n): y
   ...
   ================================
   ================================
   Creating encrypted partition...
   Enter passphrase for /dev/nvme0n1p2:
   Verify passphrase:
   Enter passphrase for /dev/nvme0n1p2:
   ...
   ================================
   ================================
   Copying configurations files...
   Proceed with installation ? (y/n): y
   ...
   Done...
   You can now reboot.
   
   # See --help option for more details:
   curios-install --help
   ```
7. If everything went according to plan, reboot.
   ```bash
   reboot now
   ```
8. **Enjoy!** User temporary password is **"changeme"**.
    You can now change it, within COSMIC desktop: click on top right power button, then Parameters > System & Accounts > Users > "Your Account Name" > Change password.
    Or use the command `passwd` in a terminal.

-----

## Features

* Hardware configuration files for AMD and Intel. GPU configuration files for AMD and Nvidia hardware.
* File system configuration for full encrypted disk (LUKS+LVM).
* COSMIC, a Wayland desktop environment / windows manager by [System76](https://system76.com/cosmic/).
* Pop_launcher, launch or switch to every application just with the Super key. Forget about your mouse, use Super key combinations for everything.
* Flatpak with **auto-update**. COSMIC and Flathub repos pre-installed.
* Alacritty terminal with ZSH and a lot of good modern commands. [My NixOS-dotfiles](https://github.com/VideoCurio/nixos-dotfiles) is pre-installed.
* [Modular configuration files](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) for apps like Steam, Discord, OBS, Ollama AI, docker, QEMU + virt-manager, Python3, Rust and more...
* Modular hardened systemd services configurations files. -WIP-
* NixOS packages **auto-update** every night or at first boot of the day.
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
| Maximize application        | Super + M                          |
| Tile mode on/off            | Super + Y                          |

### Dot files

[curios-dotfiles](https://github.com/VideoCurio/nixos-dotfiles) come pre-installed with my COSMIC theme (WIP) and for a nice Alacritty and ZSH integration.

-----

## Curi*OS* management

Activate or deactivate [modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) to suit your needs and computer's hardware. [Modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) configuration start with 'curios.'.

For example: you want to game and install Steam, Heroic launcher, Discord and more? Set: `curios.desktop.apps.gaming.enable` to `true;` into '/etc/nixos/settings.nix' file.
```bash
sudo nano /etc/nixos/settings.nix
# Use Ctrl+s to save and Ctrl+x to exit nano
```
followed by:
```bash
sudo nixos-rebuild switch
```
You want a package not in one of the already pre-configured [modules](https://github.com/VideoCurio/nixos-configuration/tree/master/modules) ? Find more packages or options configuration at [NixOS packages](https://search.nixos.org/packages?channel=25.05&size=50&sort=relevance&type=packages).

### Flatpak / desktop apps installation
You can also install Linux applications as flatpak. [Flathub](https://flathub.org/) and COSMIC repositories come pre-installed by default. You can also use the "COSMIC store" app (it is sourced with flathub and COSMIC repos) as seen below:
![COSMIC Store screenshot](https://github.com/VideoCurio/nixos-configuration/blob/master/img/Screenshot8.png?raw=true "COSMIC Store")

## NixOS management

NixOS is a Linux distribution based on the Nix package manager and build system. It supports reproducible and declarative system-wide configuration management as well as atomic upgrades and rollbacks, although it can additionally support imperative package and user management. In NixOS, all components of the distribution — including the kernel, installed packages and system configuration files — are built by Nix from pure functions called Nix expressions.
See [NixOS manual](https://nixos.org/manual/nixos/stable/) to learn more.

The default 'configuration.nix' is set to **AUTO UPDATE** every night at 03:40 or on your first boot of the day, see `systemctl list-timers`.

Generations older than 7 days are automatically garbage collected. You can also manually do the equivalent with:
```bash
sudo nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild switch --upgrade && sudo nixos-rebuild list-generations
```
Watch your root directories size with:
```bash
duf
# or
sudo du -sh /* 2>/dev/null | sort -rh
# From time to time, you can also free some space with:
sudo nix-store --gc
```

-----

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

-----

## Version

Current version is [25.05.0-rc3](https://github.com/VideoCurio/nixos-configuration/tree/release/25.05.0-rc3) based on a Nixos 25.05 build.

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

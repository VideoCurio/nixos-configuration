# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# See: https://nixos.org/manual/nixos/stable/
# man configuration.nix

{ config, lib, pkgs, ... }:

let
  # Following variables can be edited:
  timeZone = "Europe/Paris"; # Change me!!
  #defaultLocale = "en_US.UTF-8"; # Change me!!
  defaultLocale = "fr_FR.UTF-8";
  #defaultConsoleKeymap = "us"; # Change me!
  defaultConsoleKeymap = "fr";
in {
  # Split configurations files, see: https://nixos.wiki/wiki/NixOS_modules
  imports =
    [
      ##################### Step 1: Hardware #####################
      # Include the results of the hardware scan.
      # You could re-generated one with 'sudo nixos-generate-config --no-filesystems'.
      # For hardware related configurations, see: https://github.com/NixOS/nixos-hardware
      ./hardware-configuration.nix
      ##################### Step 2: Modules #####################
      # Import all modules, activate or deactivate them below
      ./modules/default.nix
      ##################### Step 3: User #####################
      # Me
      ./user-me.nix # change me !
    ];

  networking.hostName = "NixcOSmic"; # Change me!!

  # Enabling or disabling ./modules here:
  nixcosmic.platform.amd64.enable = lib.mkDefault true;
  nixcosmic.platform.rpi4.enable = lib.mkDefault false;

  nixcosmic.hardware.amdGpu.enable = lib.mkDefault false;
  nixcosmic.hardware.nvidiaGpu.enable = lib.mkDefault false;
  nixcosmic.hardware.laptop.enable = lib.mkDefault false;

  nixcosmic.filesystems.luks.enable = lib.mkDefault true;
  nixcosmic.filesystems.minimal.enable = lib.mkDefault false;

  nixcosmic.bootefi.enable = lib.mkDefault true;
  nixcosmic.desktop.cosmic.enable = lib.mkDefault true;
  nixcosmic.desktop.apps.basics.enable = lib.mkDefault true;
  nixcosmic.desktop.apps.devops.enable = lib.mkDefault false;
  nixcosmic.desktop.apps.devops.networks.enable = lib.mkDefault false;
  nixcosmic.desktop.apps.devops.python313.enable = lib.mkDefault false;
  nixcosmic.desktop.apps.devops.rust.enable = lib.mkDefault false;
  nixcosmic.desktop.apps.gaming.enable = lib.mkDefault false;
  nixcosmic.desktop.apps.studio.enable = lib.mkDefault false;
  nixcosmic.fonts.enable = lib.mkDefault true;
  nixcosmic.networking.enable = lib.mkDefault true;
  nixcosmic.services.enable = lib.mkDefault true;
  nixcosmic.services.printing.enable = lib.mkDefault false;
  nixcosmic.services.sshd.enable = lib.mkDefault true;
  nixcosmic.services.ai.enable = lib.mkDefault false;
  nixcosmic.shell.zsh.enable = lib.mkDefault true;
  nixcosmic.virtualisation.enable = lib.mkDefault false;

  # Test hardened configurations one by one
  nixcosmic.hardened.accountsDaemon.enable = lib.mkDefault false;
  nixcosmic.hardened.acipd.enable = lib.mkDefault false;
  nixcosmic.hardened.cups.enable = lib.mkDefault false;
  nixcosmic.hardened.dbus.enable = lib.mkDefault false;

  # TODO: Prevent some conflicts between modules:

  ############# Settings belows this line should not be changed! #############

  # Set your time zone.
  time.timeZone = timeZone;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  # Enable the X11 windowing system.
  #services.xserver = {
  #  enable = true;
  #  xkb.layout = defaultConsoleKeymap;
  #  xkb.options = "eurosign:e,caps:escape";
  #};

  console = {
    #font = "Lat2-Terminus16";
    keyMap = defaultConsoleKeymap;
    earlySetup = true; # initrd setup
    useXkbConfig = false; # use xkb.options in tty.
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Basics
    wget
    curl
    fastfetch
    killall
    git
    gnupg
    gnused
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  # Enabling Linux AppImage
  #programs.appimage.enable = true;
  #programs.appimage.binfmt = true;

  # Allow unfree packages, could be overridden by some modules.
  nixpkgs.config.allowUnfree = lib.mkDefault false;

  # Automatic OS updates and cleanup
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "03:40";
  # Reboot on new kernel, initrd or kernel module.
  #system.autoUpgrade.allowReboot = true;
  # Collect garbage
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}

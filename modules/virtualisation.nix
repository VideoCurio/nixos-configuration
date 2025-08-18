# Virtualisation related apps.

{ config, lib, pkgs, ... }:

{
  # Declare options
  options = {
    nixcosmic.virtualisation.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enabling virtualisation app: docker, QEMU/KVM, virt-manager.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.virtualisation.enable {
    # Docker
    virtualisation.docker.enable = true;
    # QEMU + KVM + virt-manager
    # See: https://nixos.wiki/wiki/Libvirt
    # Reboot and type this command:
    # sudo virsh net-start default && sudo virsh net-autostart default
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    # Optional: QEMU support of different arch
    # Launch this 2 commands for docker build multi platform:
    #docker run --privileged --rm tonistiigi/binfmt --install all
    #docker buildx create --name container-builder --driver docker-container --bootstrap --use
    boot.binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true; # Make it work with docker
    };

    environment.systemPackages = with pkgs; [
      # Docker
      docker-buildx
      docker-compose
      # Store creds with pass (gnupg required)
      # echo '{ "credStore": "pass" }' >> $HOME/.docker/config.json
      # gpg --full-generate-key
      # pass init dxxxxxxxxxx@xxxxxxxxxx.com
      # echo $GH_TOKEN | docker login ghcr.io -u dxxxxxxxxxxx@xxxxxxxxx.com --password-stdin
      docker-credential-helpers
      pass
      # QEMU + KVM + virt-manager
      virt-manager
      # Optional: QEMU support of different arch
      qemu-user
    ]
    ++ lib.optionals config.nixcosmic.desktop.apps.devops.python312.enable [
      pkgs.python312Packages.docker
    ];
  };
}

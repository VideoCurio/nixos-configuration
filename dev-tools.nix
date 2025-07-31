# Must be imported by configuration.nix
# DevOPS packages for work.

{ config, lib, pkgs, ... }:

{
  # Virtualisation
  virtualisation.docker.enable = true;
  # QEMU + KVM + virt-manager
  # See: https://nixos.wiki/wiki/Libvirt
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
  # Launch this command for docker build multi platform:
  #docker run --privileged --rm tonistiigi/binfmt --install all
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    preferStaticEmulators = true; # Make it work with docker
  };

  users.users.david = {
    extraGroups = [ "docker" "libvirtd" "qemu-libvirtd" "kvm" "input" "disk" ];
    # Reboot and type this command:
    # sudo virsh net-start default
    # sudo virsh net-autostart default
  };

  environment.systemPackages = with pkgs; [
    # Devops
    cloudflared
    docker-buildx
    docker-compose
    gimp3
    protonvpn-gui
    # Python3
    python313Full
    python313Packages.pip
    python313Packages.docker
    jetbrains.pycharm-community
    # Networks
    nmap
    zenmap
    wireshark # should add user to wireshark group

    # QEMU + KVM + virt-manager
    virt-manager
    # Optional: QEMU support of different arch
    qemu-user
  ];
}

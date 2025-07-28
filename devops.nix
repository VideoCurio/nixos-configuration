# Must be imported by configuration.nix
# DevOPS packages for work.

{ config, lib, pkgs, ... }:

{
  # Virtualisation
  virtualisation.docker.enable = true;
  # QEMU + KVM + virt-manager
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

  users.users.david = {
    extraGroups = [ "libvirtd" "qemu-libvirtd" "kvm" "input" "disk" ];
  };

  environment.systemPackages = with pkgs; [
    # Devops
    cloudflared
    docker-buildx
    docker-compose
    gimp3
    protonvpn-gui
    python313Full
    python313Packages.pip
    python313Packages.docker
    jetbrains.pycharm-community
    nmap
    zenmap
    wireshark # should add user to wireshark group

    # QEMU + KVM + virt-manager
    virt-manager
  ];
}
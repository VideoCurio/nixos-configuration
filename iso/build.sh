#!/usr/bin/env bash

# Build the NixcOSmic ISO file

set -eu
nix-build '<nixpkgs/nixos>' --cores 0 -A config.system.build.isoImage -I nixos-config=iso-mini.nix

# Test it:
#qemu-system-x86_64 -enable-kvm -m 4096 -cdrom result/iso/nixos-*.iso

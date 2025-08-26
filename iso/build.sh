#!/usr/bin/env bash

# Build the NixCOSMIC ISO file

set -eu
script_path="$(dirname "$0")"

branch="$(git branch --show-current)"
if [[ "$branch" != release* ]]; then
  printf "\e[31m Wrong git branch - not a release!\e[0m\n"
  #branch="release/25.05.0-RC1" # for debugging ONLY
  exit 1
fi
currentRelease=$(sed -E "s/release\/(.+)/\1/" <<< "$branch")

nix-build '<nixpkgs/nixos>' --show-trace --cores 0 --max-jobs auto -A config.system.build.isoImage -I nixos-config=iso-minimal.nix

#### Save and rename ISO file
#sleep 2s
cp "$script_path"/result/iso/nixos-minimal-*.iso "$script_path"/
for isofilename in "$script_path"/nixos-minimal-*.iso; do
  newFilename=$(sed -E "s/nixos-minimal-[0-9]{2}\.[0-9]{2}\.(.+)\.iso/nixcosmic-minimal-${currentRelease}.\1.iso/" <<< "$isofilename")
  if [ -f "$newFilename" ]; then
    printf "\e[31m ISO file already exist!\e[0m\n"
    rm -f "$script_path"/result/iso/nixos-minimal-*.iso
    exit 1
  fi
  mv "$isofilename" "$newFilename"
done

sha256sum "$newFilename" >> "$newFilename".sha256
chmod 0444 "$newFilename".sha256

printf "\e[32m Done\e[0m\n"

rm "$script_path"/result/
# sudo nix-store --gc

# Test it:
#qemu-system-x86_64 -enable-kvm -m 4096 -cdrom "$script_path"/nixcosmic-minimal-*.iso

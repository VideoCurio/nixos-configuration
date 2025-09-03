#!/usr/bin/env bash

# Build the NixCOSMIC ISO file

set -eu
script_path="$(dirname "$0")"

branch="$(git branch --show-current)"
currentRelease=""
if [[ "$branch" == testing ]]; then
  currentRelease="unstable"
else
  if [[ "$branch" != release* ]]; then
    printf "\e[31m Wrong git branch - not a release!\e[0m\n"
    #branch="release/25.05.0-RC1" # for debugging ONLY
    exit 1
  fi
  currentRelease=$(sed -E "s/release\/(.+)/\1/" <<< "$branch")
fi

isoFilename="nixcosmic-minimal_${currentRelease}_amd64-intel.iso"
isoFilePath="${script_path}/${isoFilename}"

printf "\e[32m Building %s file...\e[0m\n" "$isoFilename"
# Check if iso file already exist
while true; do
  if [ -f "$isoFilePath" ]; then
    printf "\e[33m ISO file %s already exist.\e[0m\n" "$isoFilename"
    read -r -p "Choose a variant number: " add_variant
    if ! [[ $add_variant =~ ^[0-9]+$ ]]; then
      printf "\e[31m Invalid variant number, it could only contain numerical characters.\e[0m \n"
      exit 1
    fi
    isoFilename="nixcosmic-minimal_${currentRelease}_amd64-intel-${add_variant}.iso"
    isoFilePath="${script_path}/${isoFilename}"
  else
    break;
  fi
done

# Change some version number in nix file to match $currentRelease
sed "s/nixos\.variant_id = \".*/nixos.variant_id = \"${currentRelease}\";/g" -i ./../configuration.nix
sed "s/version = \".*/version = \"${currentRelease}\";/g" -i ./../pkgs/nixcosmic-sources/default.nix

# Build packages
# nix-build && nix-env -i -f default.nix
#nix-build -E 'with import <nixpkgs> {}; callPackage ./pkgs/nixcosmic-sources {}'
#nix-shell -E 'with import <nixpkgs> {}; callPackage ./pkgs/nixcosmic-dotfiles {}'

nix-build '<nixpkgs/nixos>' --show-trace --cores 0 --max-jobs auto -A config.system.build.isoImage -I nixos-config="$script_path"/iso-minimal.nix

#### Save and rename ISO file
cp "$script_path"/result/iso/nixos-minimal-*.iso "$isoFilePath"
sha256sum "$isoFilePath" >> "$isoFilePath".sha256
chmod 0444 "$isoFilePath".sha256

printf "\e[32m Build done...\e[0m\n"

# Pushing iso file to GitHub
gh auth status
#gh auth login --hostname github.com --git-protocol ssh --web
while true; do
read -r -p "Push ISO file to GitHub.com ? (y/n): " yn
case $yn in
  [yY] ) echo "gh release upload..."
    gh release create "$currentRelease" --target "$branch" --title "$currentRelease" --prerelease --generate-notes
    gh release upload "$currentRelease" "$isoFilePath"
    gh release upload "$currentRelease" "$isoFilePath".sha256
    #git tag -a "$currentRelease" -m "Release ${currentRelease}"
    #git push --tags
    break;;
  [nN] ) echo "Proceeding without pushing...";
    break;;
  * ) echo "Invalid response";;
esac
done

printf "\e[32m All done...\e[0m\n"

#rm "$script_path"/result/

# sudo nix-store --gc

# Test it:
#qemu-system-x86_64 -enable-kvm -m 4096 -cdrom "$script_path"/nixcosmic-minimal-*.iso

# NixCOSMIC release packages
# Copy NixCOSMIC release configuration files from github into a NixOS package.
# See:
# https://nixos.org/manual/nixos/stable/index.html#sec-building-image
# https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
# https://nix.dev/tutorials/working-with-local-files#

{ lib, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  pname = "nixcosmic-release";
  version = "25.05.0-rc3";

  src = fetchFromGitHub {
    owner = "VideoCurio";
    repo = "nixos-configuration";
    rev = version;
    hash = "";
  };
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -D -m 644 -t $out/share/nixcosmic/ *.nix

    install -D -m 644 -t $out/share/nixcosmic/modules/ modules/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/desktop-apps/ modules/desktop-apps/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/filesystems/ modules/filesystems/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/hardened/ modules/hardened/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/hardware/ modules/hardware/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/platforms/ modules/platforms/*.nix

    install -D -m 644 -t $out/share/nixcosmic/pkgs/nixcosmic-dotfiles/ pkgs/nixcosmic-dotfiles/default.nix

    runHook postInstall
  '';

  meta = {
    description = "Configuration nix files for NixCOSMIC";
    homepage = "https://github.com/VideoCurio/nixos-configuration";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
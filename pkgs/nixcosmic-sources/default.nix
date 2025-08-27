# NixCOSMIC sources packages
# Copy essential NixCOSMIC configuration files from sources into a NixOS package.
# See:
# https://nixos.org/manual/nixos/stable/index.html#sec-building-image
# https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
# https://nix.dev/tutorials/working-with-local-files#

{ lib, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "nixcosmic-sources";
  version = "25.05.0-rc3";

  src = lib.fileset.toSource {
    root = ../../.;
    fileset = lib.fileset.unions [
      ../../configuration.nix
      ../../user-me.nix
      ../../modules
      ../../nixcosmic-install
    ];
  };
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -D -m 555 -t $out/bin/ nixcosmic-install
    install -D -m 644 -t $out/share/nixcosmic/ *.nix

    install -D -m 644 -t $out/share/nixcosmic/modules/ modules/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/desktop-apps/ modules/desktop-apps/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/filesystems/ modules/filesystems/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/hardened/ modules/hardened/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/hardware/ modules/hardware/*.nix
    install -D -m 644 -t $out/share/nixcosmic/modules/platforms/ modules/platforms/*.nix

    runHook postInstall
  '';

  meta = {
    description = "Configuration nix files for NixCOSMIC";
    homepage = "https://github.com/VideoCurio/nixos-configuration";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
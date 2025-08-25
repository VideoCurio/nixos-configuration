# NixCOSMIC sources packages
# Copy a release of NixCOSMIC sources from github to $out/share/
# See:
# https://nixos.org/manual/nixos/stable/index.html#sec-building-image
# https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
# https://nix.dev/tutorials/working-with-local-files#

{ lib, stdenv }:
stdenv.mkDerivation {
  pname = "nixcosmic-sources";
  version = "25.05.0-rc1";

  src = lib.fileset.toSource {
    root = ../../.;
    fileset = lib.fileset.unions [
      ../../configuration.nix
      ../../user-me.nix
      ../../modules
    ];
  };

  #dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/nixcosmic
    cp *.nix $out/share/nixcosmic/
    cp -r modules/ $out/share/nixcosmic/
    runHook postInstall
  '';

  meta = {
    description = "Configuration files for NixCOSMIC";
    homepage = "https://github.com/VideoCurio/nixos-configuration";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
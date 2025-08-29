# NixOS VideoCurio dotfiles packages.
# Set COSMIC, ZSH and various configuration files.

{ lib, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation rec {
  pname = "nixcosmic-dotfiles";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "VideoCurio";
    repo = "nixos-dotfiles";
    rev = version;
    hash = "sha256-VYsc4azd5NOM42TSJ/ixUMXGVxmDt4yEmH39d1SvIkQ=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p  $out/bin/
    mkdir -p  $out/share/
    install -D -m 555 -t $out/bin/ nixcosmic-dotfiles
    cp -r .config/ $out/share/
    install -D -m 644 -t $out/share/ .zshrc
    install -D -m 644 -t $out/share/ .zshrc-ai.plugin.zsh

    runHook postInstall
  '';

  meta = {
    description = "COSMIC Desktop Environment configuration files for NixCOSMIC";
    homepage = "https://github.com/VideoCurio/nixos-dotfiles";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
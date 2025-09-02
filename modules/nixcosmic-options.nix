# Must be imported by configuration.nix
# NixCOSMIC various custom options.

{ config, lib, ... }:

{
  # Declare options
  options = {
    nixcosmic.system.hostname = lib.mkOption {
      type = lib.types.str;
      default = "NixCOSMIC";
      description = "Set system networking hostname.";
    };
    nixcosmic.system.i18n.locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Set system i18n locale settings.";
    };
    nixcosmic.system.keyMap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Set system keyboard map settings.";
    };
    nixcosmic.system.timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Paris";
      description = "Set system time zone.";
    };
  };

  # Declare configuration
  config = {};
}

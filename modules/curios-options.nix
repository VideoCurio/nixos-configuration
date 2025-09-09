# Must be imported by configuration.nix
# CuriOS various custom options.

{ config, lib, ... }:

{
  # Declare options
  options = {
    curios.system.hostname = lib.mkOption {
      type = lib.types.str;
      default = "CuriOS";
      description = "Set system networking hostname.";
    };
    curios.system.i18n.locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Set system i18n locale settings.";
    };
    curios.system.keyboard = lib.mkOption {
      type = with lib.types; either str path;
      default = "us";
      description = "Set system keyboard map settings.";
    };
    curios.system.timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Paris";
      description = "Set system time zone. See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
          for a comprehensive list of possible values for this setting.";
    };
  };

  # Declare configuration
  config = {};
}

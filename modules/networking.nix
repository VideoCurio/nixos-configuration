# Networking settings

{ pkgs, lib, ... }:
{
  # Declare options
  options = {
    nixcosmic.networking.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NixcOSmic networking options.";
    };
  };

  # Declare configuration
  config = lib.mkIf config.nixcosmic.networking.enable {
    networking = {
      wireless.enable = false;  # Enables wireless support via wpa_supplicant OR
      networkmanager.enable = true;  # Easiest to use and most distros use this by default.
      nameservers = [ "9.9.9.9" "1.1.1.1" "2620:fe::fe" "2620:fe::9" ]; # Quad9 and cloudflare DNS servers.
      # Use DHCP to get an IP address:
      useDHCP = lib.mkDefault true;
      # Open ports in the firewall.
      #firewall.allowedTCPPorts = [ ... ];
      #firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      #firewall.enable = false;

      # Configure network proxy if necessary
      #proxy = {
      #  default = "http://user:password@proxy:port/";
      #  noProxy = "127.0.0.1,localhost,internal.domain";
      #};
    };
  };
}
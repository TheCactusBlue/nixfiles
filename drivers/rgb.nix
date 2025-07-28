{ config, pkgs, ... }:
{
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = (pkgs.openrgb-with-all-plugins); # enable all plugins
  };
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    i2c-tools
  ];
  users.groups.i2c.members = [ "hayley" ];
}

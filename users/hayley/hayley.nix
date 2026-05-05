{ config, pkgs, ... }:
{
  users.users.hayley = {
    isNormalUser = true;
    description = "hayley";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "i2c"
    ];
  };

  home-manager.users.hayley = import ./home.nix;
}

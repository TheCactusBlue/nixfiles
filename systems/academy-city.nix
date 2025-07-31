{ config, pkgs, ... }:
{
  imports = [
    ./desktop-base.nix
    ../drivers/nvidia.nix
    ../networking/host-block.nix

    # users
    ../users/hayley/hayley.nix

    ../fonts.nix
    ../locale.nix
  ];
  networking.hostName = "academy-city"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  programs.firefox.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.callPackage ../pkgs/openrgb/package.nix { };
}

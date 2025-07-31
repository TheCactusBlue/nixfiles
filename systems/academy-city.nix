{ config, pkgs, ... }:
{
  imports = [
    ./desktop-base.nix
    ../drivers/nvidia.nix
    ../drivers/rgb.nix

    # users
    ../users/hayley/hayley.nix

    ../fonts.nix
    ../locale.nix

    # move later
    ../games/hoyoverse.nix
  ];
  networking.hostName = "academy-city"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  programs.firefox.enable = true;
}

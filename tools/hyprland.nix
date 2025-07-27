{ config, pkgs, ... }:
{
  programs.hyprland.enable = true; # enable Hyprland
  environment.systemPackages = with pkgs; [
    hypridle
    hyprpolkitagent
    wofi
    waybar
  ];
  security.polkit.enable = true;
}

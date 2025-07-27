{ config, pkgs, ... }:
{
  programs.hyprland.enable = true; # enable Hyprland
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    wofi
    waybar
  ];
  security.polkit.enable = true;
}

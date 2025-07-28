{ config, pkgs, ... }:
{
  programs.hyprland.enable = true; # enable Hyprland
  environment.systemPackages = with pkgs; [
    hypridle
    hyprpolkitagent
    hyprpaper
    wofi
    waybar
    pavucontrol
  ];
  security.polkit.enable = true;
}

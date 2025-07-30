{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
  };
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;

  home.packages = [
    wofi
    waybar
    pavucontrol
    hyprshot
  ];

  environment.systemPackages = with pkgs; [
    wofi
    waybar
    pavucontrol
    hyprshot
  ];
  security.polkit.enable = true;
}

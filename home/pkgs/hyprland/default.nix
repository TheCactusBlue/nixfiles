{ config, pkgs, ... }:
{
  imports = [
    ./gtk-fix.nix
    ./settings.nix
  ];
  wayland.windowManager.hyprland.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 1800; # 30min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper = "/home/hayley/Pictures/Wallpapers/misaka_1.png";
      in
      {
        preload = [ wallpaper ];
        wallpaper = [
          "DP-5,${wallpaper}"
        ];
      };
  };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    hyprland-qt-support
    wofi
    pavucontrol
    hyprshot
    nautilus
    brightnessctl
    playerctl
  ];

  # from the wiki
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
}

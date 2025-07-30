{ config, pkgs, ... }:
{
  imports = [
    ./gtk-fix.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = import ./settings.nix;
  };

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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/home/hayley/Pictures/Wallpapers/misaka_1.png"
      ];
      wallpaper = [
        "DP-5,/home/hayley/Pictures/Wallpapers/misaka_1.png"
      ];
    };
  };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    wofi
    pavucontrol
    hyprshot
    ghostty
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

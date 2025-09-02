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
      # general = {
      #   lock_cmd = "pidof hyprlock || hyprlock";
      #   before_sleep_cmd = "loginctl lock-session";
      #   after_sleep_cmd = "hyprctl dispatch dpms on";
      # };
      listener = [
        {
          timeout = 1800; # 30min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # {
        #   timeout = 2100; # 35min
        #   on-timeout = "loginctl lock-session";
        # }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      "$font" = "Monospace";

      general = {
        hide_cursor = false;
      };

      # uncomment to enable fingerprint authentication
      # auth = {
      #   fingerprint = {
      #     enabled = true;
      #     ready_message = "Scan fingerprint to unlock";
      #     present_message = "Scanning...";
      #     retry_delay = 250; # in milliseconds
      #   };
      # };

      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 3;
        inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

        outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
        fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

        font_color = "rgb(143, 143, 143)";
        fade_on_empty = false;
        rounding = 15;

        font_family = "$font";
        placeholder_text = "Input password...";
        fail_text = "$PAMFAIL";

        # uncomment to use a letter instead of a dot to indicate the typed password
        # dots_text_format = "*";
        # dots_size = 0.4;
        dots_spacing = 0.3;

        # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
        # hide_input = true;

        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        # TIME
        {
          monitor = "";
          text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 90;
          font_family = "$font";

          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        # DATE
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B %Y"''; # update every 60 seconds
          font_size = 25;
          font_family = "$font";

          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = "$LAYOUT[en,ru]";
          font_size = 24;
          onclick = "hyprctl switchxkblayout all next";

          position = "250, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper_left = "/home/hayley/Pictures/Wallpapers/wp-upscaled-left.png";
        wallpaper_right = "/home/hayley/Pictures/Wallpapers/wp-upscaled-right.png";

      in
      {
        preload = [
          wallpaper_left
          wallpaper_right
        ];
        wallpaper = [
          "DP-2,${wallpaper_left}"
          "DP-5,${wallpaper_right}"
        ];
      };
  };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    hyprland-qt-support
    wofi
    pavucontrol
    pwvucontrol
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

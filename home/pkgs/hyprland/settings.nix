{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
with lib;
{
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration
    monitor = osConfig.desktop.hyprland.monitors ++ [ ",preferred,auto,auto" ];

    # Program variables
    "$terminal" = "ghostty";
    "$fileManager" = "nautilus";
    "$menu" = "wofi --show drun";
    "$mainMod" = "SUPER";

    # Autostart
    exec-once = [
      "systemctl --user start hyprpolkitagent"
      "waybar"
      "hypridle"
      "hyprpaper"
      "openrgb --startminimized"
    ];

    # Environment variables
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    # General settings
    general = {
      gaps_in = 5;
      gaps_out = 20;
      # border_size = 2;
      border_size = 0;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(59595900)";
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    # Decoration settings
    decoration = {
      rounding = 10;
      rounding_power = 2;
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
        enabled = false;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        enabled = true;
        size = 5;
        passes = 1;
        vibrancy = 0.1696;
      };
    };

    # Animation settings
    animations = {
      enabled = true;

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    # Workspace rules
    workspace = [
      "w[tv1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];

    # Window rules
    windowrule = [
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "rounding 0, floating:0, onworkspace:w[tv1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 0, floating:0, onworkspace:f[1]"
      "suppressevent maximize, class:.*"
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      "opacity 0.99 0.9, class:com.mitchellh.ghostty"
      "opacity 0.96 0.9, class:Code"
      "opacity 0.96 0.9, class:discord"
      "opacity 0.96 0.9, class:obsidian"
      "float, class:org.pulseaudio.pavucontrol"
      "fullscreen, class:genshinimpact.exe"
    ];

    # Layout settings
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    # Misc settings
    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };

    # Input settings
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";
      follow_mouse = 1;
      sensitivity = 0;

      touchpad = {
        natural_scroll = false;
      };
    };

    # Gestures
    gestures = {
      workspace_swipe = false;
    };

    # Device settings
    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    # Key bindings
    bind = [
      # Main binds
      "$mainMod, Return, exec, $terminal"
      "$mainMod, Q, killactive,"
      "$mainMod SHIFT, Q, exec, kill -9 $(hyprctl activewindow | grep pid | tail -1 | awk '{print$2}')"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating,"
      "$mainMod, P, exec, $menu"
      "$mainMod, J, togglesplit,"

      # Focus movement
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ]
    ++ (
      let
        workspaces =
          (genList (x: {
            name = "${toString (x + 1)}";
            keybind = "${toString (x + 1)}";
          }) 9)
          ++ [
            {
              name = "0";
              keybind = "10";
            }
          ];
      in
      lists.flatten (
        map (x: [
          "$mainMod, ${x.name}, workspace, ${x.keybind}"
          "$mainMod SHIFT, ${x.name}, movetoworkspace, ${x.keybind}"
        ]) workspaces
      )
    )
    ++ [
      # Special workspace
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Mouse workspace switching
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Screenshots
      "$mainMod, PRINT, exec, hyprshot -m window"
      ", PRINT, exec, hyprshot -m output"
      "$shiftMod, PRINT, exec, hyprshot -m region"

      # Screen control
      "$mainMod SHIFT, L, exec, hyprctl dispatch dpms toggle"
    ];

    # Mouse bindings
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Media key bindings
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
    xwayland.force_zero_scaling = true;
  };
}

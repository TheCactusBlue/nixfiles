{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  # Since Hyprland 0.55 the config is Lua, not hyprlang. Home Manager renders
  # every attribute below as an `hl.<name>(...)` call (one call per list item),
  # `_args` spreads a list into multiple call arguments, and `mkLuaInline`
  # emits a raw Lua expression instead of a quoted string.
  # See https://wiki.hypr.land/Configuring/Start/

  # Lua string literal. JSON quoting is Lua-compatible for these values.
  str = builtins.toJSON;

  # Programs
  terminal = "ghostty";
  fileManager = "nautilus";
  menu = "wofi --show drun";
  mainMod = "SUPER";

  exec = cmd: "hl.dsp.exec_cmd(${str cmd})";

  # hl.env(name, value)
  mkEnv = name: value: {
    _args = [
      name
      value
    ];
  };

  # hl.curve(name, { type = "bezier", points = { {x1, y1}, {x2, y2} } })
  mkBezier = name: x1: y1: x2: y2: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          [
            x1
            y1
          ]
          [
            x2
            y2
          ]
        ];
      }
    ];
  };

  # hl.animation({ leaf = ..., ... })
  mkAnim = leaf: speed: curve: {
    inherit leaf speed;
    enabled = true;
    bezier = curve;
  };
  mkAnimStyled =
    leaf: speed: curve: style:
    (mkAnim leaf speed curve) // { inherit style; };

  # hl.bind(keys, dispatcher, opts?)
  mkBind = opts: keys: dispatcher: {
    _args = [
      keys
      (mkLuaInline dispatcher)
    ]
    ++ lib.optional (opts != null) opts;
  };

  bind = mkBind null;
  # `locked` also fires while the session is locked, `repeating` while held.
  bindMedia = mkBind {
    locked = true;
    repeating = true;
  };
  bindLocked = mkBind { locked = true; };
  bindMouse = mkBind { mouse = true; };
in
{
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration, plus a catch-all for anything else plugged in
    monitor = osConfig.desktop.hyprland.monitors ++ [
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      }
    ];

    # Environment variables
    env = [
      (mkEnv "XCURSOR_SIZE" "24")
      (mkEnv "HYPRCURSOR_SIZE" "24")
    ];

    # Everything that used to be a bare hyprlang section lives under hl.config
    config = {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        # border_size = 2;
        border_size = 0;
        col = {
          active_border = {
            colors = [
              "rgba(33ccffee)"
              "rgba(00ff99ee)"
            ];
            angle = 45;
          };
          inactive_border = "rgba(59595900)";
        };
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

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

      animations.enabled = true;

      # Layout settings
      dwindle = {
        # pseudotile removed in Hyprland 0.56; use the `pseudo` dispatcher per-window instead
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

      xwayland.force_zero_scaling = true;
    };

    # Animation curves. `curve` is in `importantPrefixes`, so these are emitted
    # before the animations that reference them.
    curve = [
      (mkBezier "easeOutQuint" 0.23 1 0.32 1)
      (mkBezier "easeInOutCubic" 0.65 0.05 0.36 1)
      (mkBezier "linear" 0 0 1 1)
      (mkBezier "almostLinear" 0.5 0.5 0.75 1.0)
      (mkBezier "quick" 0.15 0 0.1 1)
    ];

    animation = [
      (mkAnim "global" 10 "default")
      (mkAnim "border" 5.39 "easeOutQuint")
      (mkAnim "windows" 4.79 "easeOutQuint")
      (mkAnimStyled "windowsIn" 4.1 "easeOutQuint" "popin 87%")
      (mkAnimStyled "windowsOut" 1.49 "linear" "popin 87%")
      (mkAnim "fadeIn" 1.73 "almostLinear")
      (mkAnim "fadeOut" 1.46 "almostLinear")
      (mkAnim "fade" 3.03 "quick")
      (mkAnim "layers" 3.81 "easeOutQuint")
      (mkAnimStyled "layersIn" 4 "easeOutQuint" "fade")
      (mkAnimStyled "layersOut" 1.5 "linear" "fade")
      (mkAnim "fadeLayersIn" 1.79 "almostLinear")
      (mkAnim "fadeLayersOut" 1.39 "almostLinear")
      (mkAnimStyled "workspaces" 1.94 "almostLinear" "fade")
      (mkAnimStyled "workspacesIn" 1.21 "almostLinear" "fade")
      (mkAnimStyled "workspacesOut" 1.94 "almostLinear" "fade")
    ];

    # Workspace rules — "smart gaps" / "no gaps when only"
    workspace_rule = [
      {
        workspace = "w[tv1]";
        gaps_out = 0;
        gaps_in = 0;
      }
      {
        workspace = "f[1]";
        gaps_out = 0;
        gaps_in = 0;
      }
    ];

    # Window rules. A rule is a single call now, so the paired
    # border_size/rounding rules collapse into one entry apiece.
    window_rule = [
      {
        name = "no-gaps-wtv1";
        match = {
          float = false;
          workspace = "w[tv1]";
        };
        border_size = 0;
        rounding = 0;
      }
      {
        name = "no-gaps-f1";
        match = {
          float = false;
          workspace = "f[1]";
        };
        border_size = 0;
        rounding = 0;
      }
      {
        name = "suppress-maximize-events";
        match.class = ".*";
        suppress_event = "maximize";
      }
      {
        # Fix some dragging issues with XWayland
        name = "fix-xwayland-drags";
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_initial_focus = true;
      }
      # {
      #   name = "opacity-ghostty";
      #   match.class = "com.mitchellh.ghostty";
      #   opacity = {
      #     active = 0.99;
      #     inactive = 0.9;
      #   };
      # }
      {
        name = "float-pavucontrol";
        match.class = "org.pulseaudio.pavucontrol";
        float = true;
      }
      {
        name = "fullscreen-genshin";
        match.class = "genshinimpact.exe";
        fullscreen = true;
      }
      {
        name = "tile-warudo";
        match.class = "steam_app_2079120";
        tile = true;
      }
      {
        name = "tile-vseeface";
        match.title = "^(VSeeFace)$";
        tile = true;
      }
    ];

    # Layer rules
    layer_rule = [
      {
        name = "wofi-blur";
        match.namespace = "^(wofi)$";
        blur = true;
        ignore_alpha = 0.2;
      }
    ];

    # Device settings
    device = [
      {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      }
    ];

    # Key bindings
    bind = [
      # Main binds
      (bind "${mainMod} + Return" (exec terminal))
      (bind "${mainMod} + Q" "hl.dsp.window.close()")
      # Native force-kill, replaces the old `kill -9 $(hyprctl activewindow ...)`
      (bind "${mainMod} + SHIFT + Q" "hl.dsp.window.kill()")
      (bind "${mainMod} + M" "hl.dsp.exit()")
      (bind "${mainMod} + E" (exec fileManager))
      (bind "${mainMod} + V" ''hl.dsp.window.float({ action = "toggle" })'')
      (bind "${mainMod} + P" (exec menu))
      (bind "${mainMod} + J" ''hl.dsp.layout("togglesplit")'')

      # Focus movement
      (bind "${mainMod} + left" ''hl.dsp.focus({ direction = "left" })'')
      (bind "${mainMod} + right" ''hl.dsp.focus({ direction = "right" })'')
      (bind "${mainMod} + up" ''hl.dsp.focus({ direction = "up" })'')
      (bind "${mainMod} + down" ''hl.dsp.focus({ direction = "down" })'')
    ]
    ++ (
      # Workspaces 1-10, with 10 bound to the 0 key
      lib.concatMap (
        i:
        let
          key = toString (lib.mod i 10);
        in
        [
          (bind "${mainMod} + ${key}" "hl.dsp.focus({ workspace = ${toString i} })")
          (bind "${mainMod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${toString i} })")
        ]
      ) (lib.range 1 10)
    )
    ++ [
      # Special workspace
      (bind "${mainMod} + S" ''hl.dsp.workspace.toggle_special("magic")'')
      (bind "${mainMod} + SHIFT + S" ''hl.dsp.window.move({ workspace = "special:magic" })'')

      # Mouse workspace switching
      (bind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
      (bind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

      # Screenshots
      (bind "${mainMod} + PRINT" (exec "hyprshot -m window --clipboard-only"))
      (bind "PRINT" (exec "hyprshot -m output --clipboard-only"))
      (bind "${mainMod} + SHIFT + PRINT" (exec "hyprshot -m region --clipboard-only"))

      # Screen control (no argument means toggle)
      (bind "${mainMod} + SHIFT + L" "hl.dsp.dpms()")

      # Move/resize windows with mainMod + LMB/RMB and dragging
      (bindMouse "${mainMod} + mouse:272" "hl.dsp.window.drag()")
      (bindMouse "${mainMod} + mouse:273" "hl.dsp.window.resize()")

      # Media keys
      (bindMedia "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
      (bindMedia "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      (bindMedia "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      (bindMedia "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      (bindMedia "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+"))
      (bindMedia "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-"))

      (bindLocked "XF86AudioNext" (exec "playerctl next"))
      (bindLocked "XF86AudioPause" (exec "playerctl play-pause"))
      (bindLocked "XF86AudioPlay" (exec "playerctl play-pause"))
      (bindLocked "XF86AudioPrev" (exec "playerctl previous"))
    ];
  };

  # Autostart. Kept in extraConfig so it is emitted *after* the hyprland.start
  # hook Home Manager generates for the systemd/D-Bus activation environment,
  # which hyprpolkitagent needs.
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("systemctl --user start hyprpolkitagent")
      hl.exec_cmd("waybar")
      hl.exec_cmd("hypridle")
      hl.exec_cmd("hyprpaper")
    end)
  '';
}

{
  config,
  pkgs,
  ...
}:
let
  smartGapsScript = pkgs.writeShellScript "yabai-smart-gaps" ''
    windows=$(yabai -m query --windows --space)
    count=$(echo "$windows" | ${pkgs.jq}/bin/jq '[.[] | select(."is-floating" == false and ."is-minimized" == false and ."is-hidden" == false)] | length')
    if [ "$count" -eq 1 ]; then
      wid=$(echo "$windows" | ${pkgs.jq}/bin/jq '[.[] | select(."is-floating" == false and ."is-minimized" == false and ."is-hidden" == false)] | .[0].id')
      is_fullscreen=$(yabai -m query --windows --window "$wid" | ${pkgs.jq}/bin/jq '."has-fullscreen-zoom"')
      [ "$is_fullscreen" = "false" ] && yabai -m window "$wid" --toggle zoom-fullscreen
    else
      for wid in $(echo "$windows" | ${pkgs.jq}/bin/jq '.[] | select(."has-fullscreen-zoom") | .id'); do
        yabai -m window "$wid" --toggle zoom-fullscreen
      done
    fi
  '';
in
{
  # Allow yabai to load the scripting addition without a password
  security.sudo.extraConfig = ''
    hayley ALL=(root) NOPASSWD: sha256:${builtins.hashFile "sha256" "${pkgs.yabai}/bin/yabai"} ${pkgs.yabai}/bin/yabai --load-sa
  '';

  # Yabai tiling window manager
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = 8;
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
      window_gap = 8;
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      window_opacity = "off";
      split_ratio = 0.5;
      auto_balance = "off";
    };
    extraConfig = ''
      # Load scripting addition
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa

      # Ensure at least 5 spaces exist
      current=$(yabai -m query --spaces | ${pkgs.jq}/bin/jq length)
      while [ "$current" -lt 5 ]; do
        yabai -m space --create
        current=$((current + 1))
      done

      # Smart gaps: fullscreen the window when it's the only one on a space
      yabai -m signal --add event=window_created action="${smartGapsScript}"
      yabai -m signal --add event=window_destroyed action="${smartGapsScript}"
      yabai -m signal --add event=application_launched action="${smartGapsScript}"
      yabai -m signal --add event=application_terminated action="${smartGapsScript}"

      # Unmanaged apps
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
    '';
  };

  # skhd-zig for yabai keybindings (replaces unmaintained skhd)
  environment.etc."skhdrc".text = ''
    # Focus window
    alt - h : yabai -m window --focus west
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - l : yabai -m window --focus east

    # Move window
    shift + alt - h : yabai -m window --swap west
    shift + alt - j : yabai -m window --swap south
    shift + alt - k : yabai -m window --swap north
    shift + alt - l : yabai -m window --swap east

    # Resize window
    ctrl + alt - h : yabai -m window --resize left:-50:0; yabai -m window --resize right:-50:0
    ctrl + alt - j : yabai -m window --resize bottom:0:50; yabai -m window --resize top:0:50
    ctrl + alt - k : yabai -m window --resize top:0:-50; yabai -m window --resize bottom:0:-50
    ctrl + alt - l : yabai -m window --resize right:50:0; yabai -m window --resize left:50:0

    # Toggle layout
    alt - e : yabai -m space --layout bsp
    alt - s : yabai -m space --layout stack

    # Toggle float and center
    alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

    # Toggle fullscreen
    alt - f : yabai -m window --toggle zoom-fullscreen

    # Focus space
    alt - 1 : yabai -m space --focus 1
    alt - 2 : yabai -m space --focus 2
    alt - 3 : yabai -m space --focus 3
    alt - 4 : yabai -m space --focus 4
    alt - 5 : yabai -m space --focus 5

    # Move window to space
    shift + alt - 1 : yabai -m window --space 1
    shift + alt - 2 : yabai -m window --space 2
    shift + alt - 3 : yabai -m window --space 3
    shift + alt - 4 : yabai -m window --space 4
    shift + alt - 5 : yabai -m window --space 5

    # Balance tree
    shift + alt - 0 : yabai -m space --balance

    # Rotate tree
    alt - r : yabai -m space --rotate 270
  '';

  launchd.user.agents.skhd = {
    path = [
      "/opt/homebrew/bin"
      config.environment.systemPath
    ];
    serviceConfig = {
      ProgramArguments = [
        "/opt/homebrew/bin/skhd"
        "-c"
        "/etc/skhdrc"
      ];
      KeepAlive = true;
      ProcessType = "Interactive";
    };
  };
}

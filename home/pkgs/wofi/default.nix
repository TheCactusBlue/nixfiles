{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  theme = config.custom.themes.${config.custom.currentTheme};

  # Same typeface as the editors / terminal
  fontFamily = "JetBrainsMono Nerd Font Mono";
  fontSize = 14;
in
{
  home.packages = with pkgs; [
    wofi
  ];

  xdg.configFile."wofi/config".text = ''
    show=drun
    mode=drun
    width=560
    height=400
    location=center
    prompt=❯
    term=ghostty
    insensitive=true
    allow_markup=true
    allow_images=false
    no_actions=true
    hide_scroll=true
    gtk_dark=true
    matching=fuzzy
    key_expand=Tab
  '';

  xdg.configFile."wofi/style.css".text = ''
    @define-color background ${theme.background};
    @define-color foreground ${theme.foreground};
    @define-color muted ${theme.ansi."8"};
    @define-color accent ${theme.ansi."4"};
    @define-color urgent ${theme.ansi."1"};

    * {
      font-family: "${fontFamily}", monospace;
      font-size: ${toString fontSize}px;
      border: none;
      box-shadow: none;
      outline: none;
    }

    /* A terminal window: no chrome, Hyprland's `decoration.rounding = 10`,
       and ghostty's 12px window padding. */
    window {
      background-color: alpha(@background, 0.94);
      border-radius: 10px;
      color: @foreground;
    }

    #outer-box {
      padding: 12px;
    }

    /* Prompt line — plain text on the background, like a shell prompt */
    #input {
      background-color: transparent;
      color: @foreground;
      caret-color: @accent;
      padding: 0 0 10px 0;
      margin: 0;
      min-height: 0;
    }

    #input:focus {
      background-color: transparent;
    }

    #input placeholder,
    #input image {
      color: @muted;
      opacity: 1;
    }

    #scroll,
    #inner-box {
      background-color: transparent;
      margin: 0;
    }

    /* Rows are lines of output, not cards */
    #entry {
      background-color: transparent;
      border-radius: 0;
      padding: 2px 6px;
    }

    #entry:hover {
      background-color: transparent;
      color: @accent;
    }

    /* Selection reads like a terminal selection / TUI cursor line */
    #entry:selected {
      background-color: ${theme.ansi."8"};
      border-radius: 0;
    }

    #text {
      color: @foreground;
      padding: 0;
    }

    #entry:selected #text,
    #text:selected {
      color: @foreground;
    }

    /* Fuzzy-match highlight */
    #text mark,
    #unselected mark,
    #selected mark {
      background-color: transparent;
      color: @accent;
      font-weight: bold;
    }
  '';
}

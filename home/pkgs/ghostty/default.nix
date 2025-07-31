{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  theme = config.custom.themes.${config.custom.currentTheme};
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      window-padding-x = 12;
      window-padding-y = 12;
      palette = attrValues (mapAttrs (name: value: name + "=" + value) theme.ansi);
      background = theme.background;
      foreground = theme.foreground;
      cursor-color = "#c0caf5";
      selection-background = "#283457";
      selection-foreground = "#c0caf5";
    };
  };
  programs.kitty.enable = true;
  home.shellAliases = {
    imgcat = "kitten icat";
  };
}

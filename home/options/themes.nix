{ lib, pkgs, ... }:

with lib;

{
  options.custom.themes = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          ansi = mkOption {
            type = types.attrsOf types.str;
            description = "ANSI terminal color definitions (0-15)";
            example = {
              "0" = "#000000";
              "1" = "#ff0000";
              "2" = "#00ff00";
              "3" = "#ffff00";
              "4" = "#0000ff";
              "5" = "#ff00ff";
              "6" = "#00ffff";
              "7" = "#ffffff";
              "8" = "#808080";
              "9" = "#ff8080";
              "10" = "#80ff80";
              "11" = "#ffff80";
              "12" = "#8080ff";
              "13" = "#ff80ff";
              "14" = "#80ffff";
              "15" = "#ffffff";
            };
          };

          vscode = mkOption {
            type = types.str;
            description = "Associated VSCode theme name";
            example = "Tokyo Night";
          };

          vscodePkg = mkOption {
            type = types.nullOr types.package;
            description = "VSCode extension package to install for this theme";
            default = null;
            example = "pkgs.vscode-extensions.enkia.tokyo-night";
          };

          foreground = mkOption {
            type = types.str;
            description = "Default foreground color";
            example = "#c0caf5";
          };

          background = mkOption {
            type = types.str;
            description = "Default background color";
            example = "#1a1b26";
          };
        };
      }
    );
    description = "Theme definitions with ANSI colors, VSCode theme, and foreground/background colors";
    default =
      let
        themes = [
          "one-dark"
          "tokyo-night"
        ];
      in
      listToAttrs (
        map (x: {
          name = x;
          value = import (../themes + "/${x}.nix") { inherit pkgs; };
        }) themes
      );
  };

  options.custom.currentTheme = mkOption {
    type = types.str;
    description = "Currently selected theme name";
    default = "tokyo-night";
    example = "tokyo-night";
  };
}

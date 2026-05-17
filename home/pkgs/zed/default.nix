{
  config,
  pkgs,
  lib,
  ...
}:
let
  fontFamily = "JetBrainsMono Nerd Font Mono";
  fontSize = 14;
  prettierLanguages = [
    "JavaScript"
    "JSX"
    "TypeScript"
    "TSX"
    "HTML"
    "CSS"
    "Svelte"
    "JSON"
    "JSONC"
  ];
in
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "docker"
      "dockerfile"
      "mdx"
      "toml"
    ];

    userSettings = {
      autosave = "on_focus_change";
      format_on_save = "on";
      soft_wrap = "editor_width";
      icon_theme = "Material Icon Theme";

      # theme = config.custom.themes.${config.custom.currentTheme}.zed;

      buffer_font_family = fontFamily;
      buffer_font_size = fontSize;
      buffer_font_weight = 400;
      buffer_font_features = {
        calt = true;
      };
      buffer_line_height = {
        custom = 1.3;
      };

      terminal = {
        font_family = fontFamily;
        font_size = fontSize;
        line_height = {
          custom = 1.2;
        };
      };

      inlay_hints = {
        enabled = false;
      };

      languages = lib.listToAttrs (
        map (lang: {
          name = lang;
          value = {
            formatter = "prettier";
            tab_size = 2;
          };
        }) prettierLanguages
      );
    };
  };
}

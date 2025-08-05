{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  # Get all theme packages that are not null
  themePackages = lib.filter (pkg: pkg != null) (
    lib.attrsets.mapAttrsToList (_: theme: theme.vscodePkg or null) config.custom.themes
  );
in
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          # Tooling
          ms-azuretools.vscode-docker
          bbenoist.nix
          jnoortheen.nix-ide

          # Javascript, TypeScript and CSS
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          yoavbls.pretty-ts-errors
          unifiedjs.vscode-mdx
          styled-components.vscode-styled-components
          bradlc.vscode-tailwindcss

          # Rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml

          # AI Assistance
          # anthropic.claude-code

          # QoL
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag

          # Icons
          pkief.material-icon-theme
        ]
        ++ themePackages;

      userSettings = {
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "editor.fontSize" = 15;
        "editor.lineHeight" = 1.3;
        "editor.fontWeight" = "normal";
        "editor.fontLigatures" = true;
        "editor.wordWrap" = "on";
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "terminal.integrated.fontLigatures.enabled" = true;
        "terminal.integrated.fontSize" = 15;
        "terminal.integrated.lineHeight" = 0.9;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 0;
        "editor.formatOnSave" = true;
        "workbench.colorTheme" = config.custom.themes.${config.custom.currentTheme}.vscode;
        "workbench.editor.empty.hint" = "hidden";
        "terminal.integrated.initialHint" = false;
      }
      // listToAttrs (
        map
          (lang: {
            name = "[${lang}]";
            value = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
              "editor.tabSize" = 2;
            };
          })
          [
            "typescript"
            "typescriptreact"
            "css"
          ]
      );
    };
  };

}

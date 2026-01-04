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
          svelte.svelte-vscode

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

      userSettings =
        let
          fontFamily = "JetBrainsMono Nerd Font Mono";
          fontSize = 14;
        in
        foldl' attrsets.recursiveUpdate { } [
          {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.fontFamily" = fontFamily;
            "editor.fontSize" = fontSize;
            "editor.lineHeight" = 1.3;
            "editor.fontWeight" = "normal";
            "editor.fontLigatures" = true;
            "editor.wordWrap" = "on";
            "terminal.integrated.fontFamily" = fontFamily;
            "terminal.integrated.fontLigatures.enabled" = true;
            "terminal.integrated.fontSize" = fontSize;
            "terminal.integrated.lineHeight" = 0.9;
            "files.autoSave" = "onFocusChange";
            "editor.formatOnSave" = true;
            "workbench.colorTheme" = config.custom.themes.${config.custom.currentTheme}.vscode;
            "workbench.editor.empty.hint" = "hidden";
            "terminal.integrated.initialHint" = false;
            "terminal.integrated.suggest.enabled" = false;
            "editor.inlayHints.enabled" = "offUnlessPressed";
          }
          (listToAttrs (
            map
              (lang: {
                name = "[${lang}]";
                value = {
                  "editor.defaultFormatter" = "esbenp.prettier-vscode";
                  "editor.tabSize" = 2;
                };
              })
              [
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
                "html"
                "css"
                "svelte"
              ]
          ))
        ];

      keybindings = [
        {
          key = "ctrl+c";
          command = "workbench.action.terminal.copySelection";
          when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
        }
        {
          key = "ctrl+v";
          command = "workbench.action.terminal.paste";
          when = "terminalFocus && terminalProcessSupported";
        }
      ];
    };
  };

}

{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Tooling
        ms-azuretools.vscode-docker
        bbenoist.nix

        # Javascript
        esbenp.prettier-vscode

        # Rust
        rust-lang.rust-analyzer
        tamasfe.even-better-toml

        # AI Assistance
        # anthropic.claude-code

        # QoL
        formulahendry.auto-close-tag
        formulahendry.auto-rename-tag

        # Theming
        enkia.tokyo-night
        pkief.material-icon-theme
      ];
    };
  };
}

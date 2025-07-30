{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Tooling
      ms-azuretools.vscode-docker
      bbenoist.nix

      # Rust
      rust-lang.rust-analyzer
      tamasfe.even-better-toml

      # AI Assistance
      anthropic.claude-code

      # QoL
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag
    ];
  };
}
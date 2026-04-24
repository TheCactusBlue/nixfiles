{ inputs, pkgs, ... }:
{
  imports = [
    ../../home/home-base.nix
  ]
  ++ map (path: ../../home/pkgs + path) [
    # development
    /zsh/default.nix
    /git/default.nix
    /direnv/default.nix
    /nodejs/default.nix
    /python/default.nix

    # development tools
    /vscode/default.nix
    /claude-code/default.nix
    /nh/default.nix

    # ricing
    /neofetch/default.nix
  ];

  custom = {
    currentTheme = "tokyo-night";
  };

  home.packages = with pkgs; [
    obsidian
    htop
    jq
    cmatrix
    cbonsai
    uv
    rustup
    just
  ];

  programs.git.settings.user = {
    name = "TheCactusBlue";
    email = "thecactusblue@gmail.com";
  };

  home.username = "hayley";
  home.homeDirectory = "/Users/hayley";
  home.stateVersion = "25.05";
}

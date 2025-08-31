{ pkgs, ... }:
{
  imports = [
    ../../home/home-base.nix
  ]
  ++ map (path: ../../home/pkgs + path) [
    /hyprland/default.nix
    /waybar/default.nix
    /ghostty/default.nix

    # general
    /firefox/default.nix

    # development
    /zsh/default.nix
    /git/default.nix
    /nodejs/default.nix
    /rust/default.nix

    # development tools
    /vscode/default.nix
    /claude-code/default.nix

    # communication
    /discord/default.nix

    # gaming
    /minecraft/default.nix
    /hoyoverse/default.nix

    # ricing
    /neofetch/default.nix
    /ags/default.nix
  ];

  programs.obsidian.enable = true;

  custom = {
    currentTheme = "tokyo-night";
  };

  home.packages = with pkgs; [
    htop
    cmatrix
    cbonsai
    cava
    zenith-nvidia
    pciutils
    pinta
    trezor-suite
    nur.repos.charmbracelet.crush
  ];

  programs.git = {
    userName = "TheCactusBlue";
    userEmail = "thecactusblue@gmail.com";
  };

  home.stateVersion = "25.05";
}

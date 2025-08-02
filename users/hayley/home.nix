{ pkgs, ... }:
{
  imports = [
    ../../home/home-base.nix
  ]
  ++ map (path: ../../home/pkgs + path) [
    /hyprland/default.nix
    /waybar/default.nix
    /ghostty/default.nix

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
  ];

  custom = {
    currentTheme = "tokyo-night";
  };

  programs.firefox.enable = true;
  home.packages = with pkgs; [
    htop
    cmatrix
    cbonsai
    cava
    zenith-nvidia
    pciutils
    pinta
    nur.repos.charmbracelet.crush
  ];

  programs.git = {
    userName = "TheCactusBlue";
    userEmail = "thecactusblue@gmail.com";
  };

  home.stateVersion = "25.05";
}

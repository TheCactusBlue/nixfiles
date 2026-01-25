{ inputs, pkgs, ... }:
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

  custom = {
    currentTheme = "tokyo-night";
  };

  home.packages = with pkgs; [
    obsidian
    htop
    # openrgb
    cmatrix
    cbonsai
    cava
    zenith-nvidia
    pciutils
    pinta
    trezor-suite
    nur.repos.charmbracelet.crush
    moon
    wineWowPackages.stable
    gparted
    tor
    monero-gui
    inputs.hytale-launcher.packages.${pkgs.system}.default
  ];

  programs.git.settings.user = {
    name = "TheCactusBlue";
    email = "thecactusblue@gmail.com";
  };

  home.stateVersion = "25.05";
}

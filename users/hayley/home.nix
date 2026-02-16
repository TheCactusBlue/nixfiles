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
    /direnv/default.nix
    /nodejs/default.nix
    /rust/default.nix
    /python/default.nix

    # development tools
    /vscode/default.nix
    /claude-code/default.nix
    /nh/default.nix

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
    jq
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
    microsoft-edge

    uv
    racket
  ];

  programs.git.settings.user = {
    name = "TheCactusBlue";
    email = "thecactusblue@gmail.com";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.stateVersion = "25.05";
}

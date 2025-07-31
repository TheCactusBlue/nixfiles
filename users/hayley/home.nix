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

    # gaming
    /minecraft/default.nix
  ];

  custom = {
    currentTheme = "tokyo-night";
  };

  home.packages = with pkgs; [
    neofetch
    htop
    cmatrix
    cbonsai
    cava
    zenith-nvidia
    pciutils
    discord
    pinta
  ];

  programs.git = {
    enable = true;
    userName = "TheCactusBlue";
    userEmail = "thecactusblue@gmail.com";
    extraConfig = {
      push.AutoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };

  programs.hyfetch = {
    enable = true;
    settings = { };
  };

  home.stateVersion = "25.05";
}

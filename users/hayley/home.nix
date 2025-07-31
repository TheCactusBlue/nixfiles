{ pkgs, ... }:
{
  imports = map (path: ../../home/pkgs + path) [
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

  nixpkgs.config.allowUnfree = true;
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
  home.stateVersion = "25.05";

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
}

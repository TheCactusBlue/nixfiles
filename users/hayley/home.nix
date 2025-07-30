{ pkgs, ... }:
{
  imports = [
    ../../home/pkgs/hyprland/default.nix
    ../../home/pkgs/waybar/default.nix
    ../../home/pkgs/ghostty/default.nix

    # development
    ../../home/pkgs/zsh/default.nix
    ../../home/pkgs/git/default.nix
    ../../home/pkgs/nodejs/default.nix
    ../../home/pkgs/rust/default.nix

    # gaming
    ../../home/pkgs/minecraft/default.nix
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

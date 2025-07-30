{ pkgs, ... }:
{
  imports = [
    ../../tools/hyprland/hyprland.nix
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

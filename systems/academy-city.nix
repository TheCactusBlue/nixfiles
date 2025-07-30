{ config, pkgs, ... }:
{
  imports = [
    ../drivers/nvidia.nix
    ../drivers/rgb.nix

    ../home/home-manager.nix

    ../programming/claude-code.nix

    ../users/hayley/hayley.nix
    ../games/hoyoverse.nix

    ../fonts.nix
    ../locale.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = "academy-city"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  programs.firefox.enable = true;
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  security.polkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    kitty
    direnv
    cachix
  ];
}

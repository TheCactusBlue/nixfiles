{ config, pkgs, ... }:
{
  imports = [
    ../desktop-base.nix

    ../../options/hyprland.nix

    ../../drivers/nvidia.nix
    ../../networking/host-block.nix

    # users
    ../../users/hayley/hayley.nix

    ../../fonts.nix
    ../../locale.nix
  ];
  networking.hostName = "academy-city"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";

  desktop.hyprland.monitors = [
    "DP-5, 2560x1440@60, 0x0, 1"
    "DP-4, 2560x682@60, 2560x0, 2, transform, 3" # Hyte Y70 monitor
  ];

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  programs.firefox.enable = true;
  services.hardware.openrgb.enable = true;
}

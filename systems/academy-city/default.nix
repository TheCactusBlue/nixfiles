{
  config,
  pkgs,
  inputs,
  ...
}:
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
    "DP-5, 3840x2160@60, 0x0, 1.5"
    "DP-4, 2560x682@60, 2560x0, 1, transform, 3" # Hyte Y70 monitor - scaled to ~1600 pxs
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  security.pam.services.hyprlock = { };
  services.hardware.openrgb.enable = true;
}

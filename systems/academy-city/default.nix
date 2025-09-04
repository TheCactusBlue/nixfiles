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
    "DP-2, 2560x1440@60, 0x0, 1"
    "DP-5, 3840x2160@60, 2560x0, 1.5"
    "DP-4, 2560x682@60, 5120x0, 1, transform, 3" # Hyte Y70 monitor - scaled to ~1600 pxs
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  security.pam.services.hyprlock = { };
  services.hardware.openrgb.enable = true;
  services.trezord.enable = true;
}

{
  config,
  lib,
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

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  desktop.hyprland.monitors = [
    {
      output = "DP-4";
      mode = "2560x1440@60";
      position = "0x0";
      scale = "1";
    }
    {
      output = "DP-5";
      mode = "3840x2160@60";
      position = "2560x0";
      scale = "1.5";
    }
    # Hyte Y70 monitor - scaled to ~1600 pxs
    {
      output = "DP-2";
      mode = "2560x682@60";
      position = "5120x0";
      scale = "1";
      transform = 3;
    }
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  environment.systemPackages = with pkgs; [
    bottles
  ];

  programs.zsh.enable = true;
  programs.hyprland.enable = true; # Need for global hyprland
  security.pam.services.hyprlock = { };
  services.trezord.enable = true;

  # OpenRGB: udev rules + i2c only. The SDK daemon is left off because it
  # claims USB HID devices and blocks GUI writes; uaccess lets the GUI work.
  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };
}

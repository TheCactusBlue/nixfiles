{ config, pkgs, ... }:
{
  imports = [
    ../drivers/boot.nix
    ../drivers/audio.nix
    ../home/home-manager.nix
  ];
  # Enable networking
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gvfs.enable = true;
  services.printing.enable = true;

  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    direnv
    cachix
  ];
}

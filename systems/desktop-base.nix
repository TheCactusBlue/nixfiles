{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./base.nix
    ../drivers/boot.nix
    ../drivers/audio.nix
    ../home/home-manager.nix
  ];

  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services = {
    xserver.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    printing.enable = true;
    flatpak.enable = true;
  };

  virtualisation.docker.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    direnv
    cachix
  ];
}

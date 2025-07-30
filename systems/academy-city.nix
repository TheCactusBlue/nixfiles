{ config, pkgs, ... }:
{
  imports = [
    ../drivers/nvidia.nix
    ../drivers/rgb.nix

    ../tools/vscode.nix
    ../home/home-manager.nix

    ../programming/claude-code.nix

    ../users/hayley/hayley.nix
    ../games/hoyoverse.nix

    ../fonts.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = "academy-city"; # Define your hostname.
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

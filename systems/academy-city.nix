{ config, pkgs, ... }:
{
  imports = [
    ../drivers/nvidia.nix
    ../drivers/rgb.nix

    ../tools/hyprland.nix
    # ../tools/waybar.nix
    ../tools/vscode.nix
    ../tools/zsh.nix
    ../tools/home-manager.nix

    ../programming/claude-code.nix
    ../programming/docker.nix
    ../programming/git.nix
    ../programming/nodejs.nix
    ../programming/rust.nix

    ../users/hayley.nix
    ../games/minecraft.nix
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

  # Install firefox.
  programs.firefox.enable = true;
  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixfmt-rfc-style
    ghostty
    kitty
    direnv
    cachix
  ];
}

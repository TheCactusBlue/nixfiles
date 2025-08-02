{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neofetch
    imagemagick
  ];

  programs.hyfetch = {
    enable = true;
  };

  home.file.".config/neofetch/config.conf".source = ./config.conf;
}

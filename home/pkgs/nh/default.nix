{ config, pkgs, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/hayley/Projects/nix";

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}

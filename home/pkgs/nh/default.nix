{ config, pkgs, ... }:
let
  flakePath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/hayley/Projects/nixfiles"
    else
      "/home/hayley/Projects/nix";
in
{
  programs.nh = {
    enable = true;
    flake = flakePath;

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}

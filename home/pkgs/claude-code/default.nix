# configuration.nix
{ config, pkgs, ... }:
let
  unstable =
    import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable")
      { config = config.nixpkgs.config; };
in
{
  home.packages = with pkgs; [
    unstable.claude-code
    ripgrep
  ];
}

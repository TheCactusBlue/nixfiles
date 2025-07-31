{ pkgs, ... }:
{
  imports = [
    ./options/themes.nix
  ];

  nixpkgs.config.allowUnfree = true;
}

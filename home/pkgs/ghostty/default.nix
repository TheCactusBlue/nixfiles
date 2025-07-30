{ config, pkgs, ... }:
{
  programs.ghostty.enable = true;
  programs.kitty.enable = true;
  home.shellAliases = {
    imgcat = "kitten icat";
  };
}

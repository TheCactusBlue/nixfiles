{ pkgs, inputs, ... }:
{
  home.packages = [ inputs.aagl-gtk-on-nix.packages.${pkgs.system}.an-anime-game-launcher ];
}

{ pkgs, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ../ags;
    # additional packages and executables to add to gjs's runtime
    extraPackages = with pkgs; [ ];
  };
  home.packages = [
    inputs.astal.packages.${pkgs.system}.io
    inputs.astal.packages.${pkgs.system}.notifd
  ];
}

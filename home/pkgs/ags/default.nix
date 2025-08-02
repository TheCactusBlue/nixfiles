{ pkgs, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    configDir = ../ags;
    # additional packages and executables to add to gjs's runtime
    extraPackages =
      (with pkgs; [ ])
      ++ (with inputs.astal.packages.${pkgs.system}; [
        hyprland
      ]);
  };
  home.packages = [
    inputs.astal.packages.${pkgs.system}.io
    inputs.astal.packages.${pkgs.system}.notifd
  ];
}

{ config, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
  environment.shellAliases = {
    imgcat = "kitten icat";
  };
}

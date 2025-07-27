{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    ohMyZsh = { # "ohMyZsh" without Home Manager
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
  };
}
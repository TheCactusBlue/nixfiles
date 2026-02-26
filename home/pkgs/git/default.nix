{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      push.AutoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
  programs.lazygit = {
    enable = true;
  };
  programs.gh = {
    enable = true;
  };
}

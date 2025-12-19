{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      push.AutoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
  programs.gh.enable = true;
}

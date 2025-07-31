{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      push.AutoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
  programs.gh.enable = true;
}

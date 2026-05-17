{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      pull.rebase = true;
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

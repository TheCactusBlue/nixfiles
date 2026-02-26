{ config, pkgs, ... }:
{
  home.file.".oh-my-zsh-custom/themes/mikoto.zsh-theme".source = ./mikoto.zsh-theme;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      custom = "${config.home.homeDirectory}/.oh-my-zsh-custom";
      theme = "mikoto";
    };

    # You can add the zsh-nix-shell plugin declaratively too
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

    initExtra = ''
      alias clod="claude"
    '';
  };
}

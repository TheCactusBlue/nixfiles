{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      theme = "robbyrussell";
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
      # Show nix-shell indicator in prompt
      if [[ -n "$IN_NIX_SHELL" ]]; then
        PROMPT="%{$fg[cyan]%}❄ %{$reset_color%} $PROMPT"
      fi
      alias clod="claude"
    '';
  };
}

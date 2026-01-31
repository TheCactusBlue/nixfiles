{
  config,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  programs.claude-code = {
    enable = true;
    settings = {
      model = "opus";

      allow = [
        "WebSearch"
      ]
      ++ map (cmd: "Bash(${cmd})") [
        "find:*"
        "rg:*"
        "echo:*"
        "grep:*"
        "ls:*"
        "cat:*"
        "sed:*"
        "source:*"
        "tree:*"
        "tail:*"

        "gh pr list:*"
        "gh pr view:*"
        "gh pr diff:*"
        "gh api user:*"
        "gh repo view:*"
        "gh issue view:*"
        "git branch --show-current:*"
        "git diff:*"
        "git status:*"
        "git rev-parse:*"
        "git push:*"
        "git log:*"
      ]
      ++ map (site: "WebFetch(domain:${site})") [
        "docs.rs"
        "github.com"
        "raw.githubusercontent.com"
        "openai.com"
        "anthropic.com"
        "docs.anthropic.com"
      ];

      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
      };
    };

  };
  home.packages = with pkgs; [
    bubblewrap
    socat
    ripgrep
  ];
}

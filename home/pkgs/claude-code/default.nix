{
  config,
  pkgs,
  inputs,
  ...
}:
let
  allowedDomains = [
    "docs.rs"
    "github.com"
    "raw.githubusercontent.com"
    "openai.com"
    "anthropic.com"
    "docs.anthropic.com"
    "www.npmjs.com"
  ];
in
{
  programs.claude-code = {
    enable = true;
    settings = {
      permissions.allow = [
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
      ++ map (site: "WebFetch(domain:${site})") allowedDomains;

      statusLine = {
        command = builtins.readFile ./statusline.sh;
        padding = 0;
        type = "command";
      };

      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };

      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
        network.allowedDomains = allowedDomains;
        excludedCommands = [
          "git"
          "docker"
        ];
      };
    };

  };
  home.packages = with pkgs; [
    bubblewrap
    socat
    ripgrep
  ];
}

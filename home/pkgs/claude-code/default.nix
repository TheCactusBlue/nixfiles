{
  config,
  pkgs,
  inputs,
  ...
}:
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
      ++ map (site: "WebFetch(domain:${site})") [
        "docs.rs"
        "github.com"
        "raw.githubusercontent.com"
        "openai.com"
        "anthropic.com"
        "docs.anthropic.com"
      ];

      statusLine = {
        command = ''
          input=$(cat)
          model=$(echo "$input" | jq -r '.model.display_name')
          dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")
          context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
          branch=$(echo "$input" | jq -r '.workspace.git.branch // empty')

          # Colors
          reset='\033[0m'
          cyan='\033[36m'
          yellow='\033[33m'
          green='\033[32m'
          magenta='\033[35m'
          dim='\033[2m'

          out="$dim[$reset$cyan$model$reset$dim]$reset 📁 $yellow$dir$reset $dim|$reset 📊 $green$context_pct%$reset"
          [ -n "$branch" ] && out="$out $dim|$reset 🌿 $magenta$branch$reset"
          echo -e "$out"
        '';
        padding = 0;
        type = "command";
      };

      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };

      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
        network.allowAllUnixSockets = true;
      };
    };

  };
  home.packages = with pkgs; [
    bubblewrap
    socat
    ripgrep
  ];
}

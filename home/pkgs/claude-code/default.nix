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
        command = ''
          input=$(cat)
          model=$(echo "$input" | jq -r '.model.display_name')
          dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")
          context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
          branch=$(echo "$input" | jq -r '.workspace.git.branch // empty')

          # Mikoto-style segment builder: colored bg cells with contrasting text
          # Usage: segment "r;g;b" "r;g;b" "content" (bg rgb, fg rgb)
          segment() { printf '\033[48;2;%sm\033[38;2;%sm %s \033[0m' "$1" "$2" "$3"; }
          sep() { printf '\033[38;2;74;74;82m─\033[0m'; }

          out=""
          out+="$(segment '28;28;34' '156;163;175' "$model")"
          out+="$(segment '6;182;212' '255;255;255' "$dir")"
          out+="$(sep)"
          out+="$(segment '139;92;246' '255;255;255' "$context_pct%")"
          [ -n "$branch" ] && out+="$(sep)$(segment '37;99;235' '255;255;255' "$branch")"
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

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
  bwrapWrapper = pkgs.writeShellScriptBin "bwrap" ''
    snapshot=$(mktemp)
    after=$(mktemp)
    trap 'rm -f "$snapshot" "$after"' EXIT
    {
      find . -maxdepth 1 ! -name .
      [ -d .claude ] && find .claude -maxdepth 1 ! -name .claude
    } 2>/dev/null | sort > "$snapshot"
    ${pkgs.bubblewrap}/bin/bwrap "$@"
    rc=$?
    {
      find . -maxdepth 1 ! -name .
      [ -d .claude ] && find .claude -maxdepth 1 ! -name .claude
    } 2>/dev/null | sort > "$after"
    comm -13 "$snapshot" "$after" | while IFS= read -r f; do
      [ -f "$f" ] && [ ! -s "$f" ] && rm -f "$f" 2>/dev/null
    done
    exit "$rc"
  '';
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
    bwrapWrapper
    socat
    ripgrep
  ];
}

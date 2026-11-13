{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  allowedDomains = [
    # Repositories
    "github.com"
    "raw.githubusercontent.com"
    # Rust
    "docs.rs"
    "crates.io"
    "*.crates.io"
    # JS
    "npmjs.com"
    # Python
    "pypi.org"
    # AI
    "anthropic.com"
    "*.anthropic.com"
    "openai.com"
  ];
in
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      voiceEnabled = true;
      skipAutoPermissionPrompt = true;
      remoteControlAtStartup = false;
      idleCompaction = false;
      permissions.defaultMode = "auto";
      permissions.allow = [
        "Skill(*)"
        "WebSearch"
        "Read(~/.cargo/**)"
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
        CLAUDE_CODE_NO_FLICKER = "1";
        # Don't attach to the editor (Zed/VSCode terminals auto-connect otherwise),
        # which is what injects the "⧉ In <file>" open-file/selection context.
        CLAUDE_CODE_AUTO_CONNECT_IDE = "false";
      };

      spinnerVerbs = {
        mode = "append";
        verbs = [
          "Brainrotting"
          "Caffeinating"
          "Illuminating"
          "Herding"
          "Estrogenizing"
          "Force Feminizing"
          "Clairing"
          "Engineering"
          "Mutating"
          "Hyperstitioning"
          "Shipping"
          "Constructing"
          "Warping"
          "Magnetizing"
          "Watering"
          "Annihilating"
          "Aura Farming"
          "Procrastinating"
          "Imbuing"
        ];
      };
    };
    mcpServers = {
      playwright = {
        type = "stdio";
        command = "mcp-server-playwright";
        args = [ ];
        env = { };
      };
    };

  };
  home.packages =
    with pkgs;
    [
      ripgrep
      sox
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      xclip
      playwright-mcp
    ];
}

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../base.nix
    ../../pkgs/yabai
  ];

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    CustomUserPreferences."com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlight search: Option+Space instead of Cmd+Space
        "64" = {
          enabled = true;
          value = {
            parameters = [
              32
              49
              524288
            ];
            type = "standard";
          };
        };
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew for GUI apps not in nixpkgs
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [
      "jackielii/tap"
    ];
    brews = [
      "jackielii/tap/skhd-zig"
    ];
    casks = [
      "firefox"
      "discord"
      "ghostty"
    ];
  };

  system.primaryUser = "hayley";

  users.users.hayley = {
    name = "hayley";
    home = "/Users/hayley";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    direnv
    cachix
  ];

  # Used for backwards compatibility
  system.stateVersion = 6;
}

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../base.nix
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
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew for GUI apps not in nixpkgs
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
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

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    direnv
    cachix
  ];

  # Used for backwards compatibility
  system.stateVersion = 6;
}

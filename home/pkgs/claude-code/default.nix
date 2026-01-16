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
  };
  home.packages = with pkgs; [
    ripgrep
  ];
}

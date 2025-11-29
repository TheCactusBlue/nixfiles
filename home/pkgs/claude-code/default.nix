{
  config,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  home.packages = with pkgs; [
    claude-code
    ripgrep
  ];
}

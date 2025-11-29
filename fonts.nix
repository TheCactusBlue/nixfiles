{ config, pkgs, ... }:
{
  # Fonts
  fonts.packages = with pkgs; [
    corefonts
    roboto
    open-sans
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerd-fonts.jetbrains-mono
  ];
}

{ pkgs, ... }:
{
  vscode = "One Dark Pro";
  vscodePkg = pkgs.vscode-extensions.zhuangtongfa.material-theme;
  background = "#282c34";
  foreground = "#abb2bf";
  ansi = {
    "0" = "#282c34";
    "1" = "#e06c75";
    "2" = "#98c379";
    "3" = "#e5c07b";
    "4" = "#61afef";
    "5" = "#c678dd";
    "6" = "#56b6c2";
    "7" = "#abb2bf";
    "8" = "#5c6370";
    "9" = "#e06c75";
    "10" = "#98c379";
    "11" = "#e5c07b";
    "12" = "#61afef";
    "13" = "#c678dd";
    "14" = "#56b6c2";
    "15" = "#ffffff";
  };
}
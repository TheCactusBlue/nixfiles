{ lib, pkgs, ... }:

with lib;
{
  options.desktop.hyprland.monitors = mkOption {
    type = types.listOf types.str;
    description = "List of system monitor configs for hyprland";
    default = [ ];
    example = [
      "DP-5, 3840x2160@60, 0x0, 1"
      "DP-4, 2560x682@60, 3840x0, 2, transform, 3"
    ];
  };
}

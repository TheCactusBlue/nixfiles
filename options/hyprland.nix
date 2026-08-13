{ lib, pkgs, ... }:

with lib;
{
  options.desktop.hyprland.monitors = mkOption {
    type = types.listOf (
      types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.bool
        ]
      )
    );
    description = ''
      List of system monitor configs for hyprland. Each entry is passed
      verbatim to `hl.monitor` in the generated Lua config, so the keys are
      the ones documented at
      <https://wiki.hypr.land/Configuring/Basics/Monitors/>.

      `mode`, `position` and `scale` are strings (they accept keywords like
      `preferred`/`auto`), `transform` is an integer.
    '';
    default = [ ];
    example = [
      {
        output = "DP-5";
        mode = "3840x2160@60";
        position = "0x0";
        scale = "1";
      }
      {
        output = "DP-4";
        mode = "2560x682@60";
        position = "3840x0";
        scale = "2";
        transform = 3;
      }
    ];
  };
}

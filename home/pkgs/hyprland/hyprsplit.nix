{
  ...
}:
{
  # awesome/dwm-like workspaces: each monitor gets its own independent set of
  # `num_workspaces` workspaces, and the workspace binds act on the focused
  # monitor's set.
  #
  # Upstream replaced the C++ plugin with a Lua library; see ./hyprsplit/README.md
  # for provenance and update instructions.
  wayland.windowManager.hyprland.extraLuaFiles = {
    # The library itself. autoLoad = false because loading it bare would do
    # nothing useful — hyprsplit-config below pulls it in via require() and
    # configures it. Home Manager writes this to
    # ~/.config/hypr/hyprsplit/init.lua, which `require("hyprsplit")` finds via
    # the `hypr/?/init.lua` entry it adds to package.path.
    "hyprsplit/init" = {
      content = ./hyprsplit/init.lua;
      autoLoad = false;
    };

    # Loaded automatically. Home Manager emits its require() *before* the
    # settings block in hyprland.lua, so hyprsplit's event handlers are
    # registered and its config applied by the time the binds in settings.nix
    # call `require("hyprsplit")`.
    "hyprsplit-config" = {
      autoLoad = true;
      content = ''
        local hs = require("hyprsplit")

        hs.config({
          -- Workspaces per monitor. Matches the 1-10 binds in settings.nix.
          num_workspaces = 10,
          -- Workspaces are created on demand and torn down when empty.
          persistent_workspaces = false,
        })

        -- No monitor_priority: workspace blocks are assigned by Hyprland
        -- monitor id, which is what the old plugin defaulted to. To pin them to
        -- specific outputs instead (1-10 on the first listed, 11-20 on the
        -- next, ...), uncomment and list them in the desired order:
        -- hs.monitor_priority({ "DP-4", "DP-5", "DP-2" })
      '';
    };
  };
}

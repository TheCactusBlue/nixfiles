# Vendored hyprsplit

`init.lua` is a **verbatim** copy of upstream
[shezdy/hyprsplit](https://github.com/shezdy/hyprsplit) at commit
`6b00b677d8905fb38779c91e12d6294e0e586a44`.

## Why vendored

Upstream deprecated the C++ plugin in favour of a pure-Lua library that runs on
Hyprland's Lua config API (requires Hyprland >= 0.55). nixpkgs still packages
only the old plugin (`hyprlandPlugins.hyprsplit`, `0.54.3-unstable-2026-06-11`),
which does not build against the Hyprland we run — that's why
`plugins = [ pkgs.hyprlandPlugins.hyprsplit ]` was commented out.

The upstream flake exposes the Lua version as `packages.<system>.hyprsplitlua`,
but that output is just `cp init.lua $out/share/hyprsplit/`. Taking it as a
flake input would drag the entire Hyprland flake (and a second nixpkgs) into
`flake.lock` to copy one file, so the file is checked in instead.

## Updating

```bash
curl -sL https://raw.githubusercontent.com/shezdy/hyprsplit/main/init.lua \
  -o home/pkgs/hyprland/hyprsplit/init.lua
```

Then update the commit hash above. Do not edit `init.lua` locally — keep it
byte-identical to upstream so updates stay a straight overwrite. Local
configuration belongs in `hyprsplit.nix`.

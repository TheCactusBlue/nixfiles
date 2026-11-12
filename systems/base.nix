{
  config,
  pkgs,
  inputs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nur.overlays.default

    # moon 2.6.4 in nixpkgs lacks aws-lc and libzstd, so the aws-lc-sys and
    # zstd-sys build scripts fail. Upstream added both in 2.6.5; drop this once
    # that lands in nixos-unstable.
    (final: prev: {
      moon = prev.moon.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          final.aws-lc
          final.zstd
        ];
      });
    })
  ];
}

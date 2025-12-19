{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" ];
    })
    llvmPackages_21.libcxxClang # for C/C++ compilation with Rust
    just
  ];
}

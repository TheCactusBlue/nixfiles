{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    llvmPackages_21.libcxxClang # for C/C++ compilation with Rust
    just
  ];
}

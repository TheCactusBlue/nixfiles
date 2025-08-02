# NixOS Configuration

Personal NixOS configuration. I'm pretty new to NixOS, so this is probably all wrong on how it's set up.

![System Screenshot](examples/screenshot.png)

## System Info

- NixOS
- Hyprland
- Waybar

## How to use

This configuration now uses Nix flakes.

### Using the flake

1. Clone this repository
2. Build and switch to the configuration:

```sh
sudo nixos-rebuild switch --flake .#academy-city
```

**Note:** The hardware configuration is included in this repository. If you're using this on a different machine, you may need to update `hardware-configuration.nix` with your system's specific hardware settings.

### Traditional method (deprecated)

Alternatively, modify your /etc/nixos/configuration.nix to look like this:

```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    /home/hayley/Projects/nix/systems/academy-city.nix
  ];

  system.stateVersion = "25.05";
}
```

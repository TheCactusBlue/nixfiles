# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal NixOS configuration using Nix flakes, Hyprland window manager, and Home Manager. The configuration is modular and organized for a system called "academy-city".

## Essential Commands

### System Management
```bash
# Build and switch to the configuration
sudo nixos-rebuild switch --flake .#academy-city

# Test configuration without switching
sudo nixos-rebuild test --flake .#academy-city

# Build configuration
sudo nixos-rebuild build --flake .#academy-city
```

### Development
```bash
# Enter development shell with formatting tools
nix develop

# Format Nix files
nixfmt-rfc-style **/*.nix

# Explore package dependencies
nix-tree
```

### Flake Operations
```bash
# Update flake inputs
nix flake update

# Show flake info
nix flake show

# Check flake for issues
nix flake check
```

## Architecture

### System Structure
- `flake.nix` - Main flake configuration with inputs (nixpkgs, home-manager, aagl-gtk-on-nix)
- `systems/` - System-specific configurations
  - `academy-city/` - Primary system configuration with hardware-configuration.nix
  - `desktop-base.nix` - Common desktop configuration
- `home/` - Home Manager configurations
  - `home-base.nix` - Base home configuration
  - `pkgs/` - Application-specific configurations organized by package
  - `themes/` - UI themes (one-dark, tokyo-night)
- `users/hayley/` - User-specific configurations
- `drivers/` - Hardware drivers (nvidia, audio, boot)
- `options/` - Custom NixOS options
- `networking/` - Network configurations

### Key Configuration Patterns
- Modular design with imports spreading functionality across files
- Home Manager integration for user-space configuration
- Custom options defined in `options/` directory
- Package configurations in `home/pkgs/` follow a standardized `default.nix` structure
- Theme system with `currentTheme` option set in user configuration

### Development Tools Included
- nixfmt-rfc-style for code formatting
- direnv for environment management
- nix-tree for dependency visualization
- Development packages: nodejs, rust, git, vscode, claude-code

### Monitor Configuration
The system supports multi-monitor setups defined in `systems/academy-city/default.nix` using Hyprland's monitor configuration syntax.
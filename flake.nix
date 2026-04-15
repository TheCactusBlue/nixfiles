{
  description = "Hayley's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl-gtk-on-nix = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

    hytale-launcher.url = "github:TNAZEP/HytaleLauncherFlake";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        academy-city = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./systems/academy-city/hardware-configuration.nix
            ./systems/academy-city/default.nix
            {
              nixpkgs.overlays = [
                inputs.rust-overlay.overlays.default
                inputs.claude-code.overlays.default
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.hayley = import ./users/hayley/home.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        tokiwadai = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./systems/tokiwadai/default.nix
            inputs.mac-app-util.darwinModules.default
            {
              nixpkgs.overlays = [
                inputs.rust-overlay.overlays.default
                inputs.claude-code.overlays.default
              ];
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hmbackup";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                inputs.mac-app-util.homeManagerModules.default
              ];
              home-manager.users.hayley = import ./users/hayley/home-darwin.nix;
            }
          ];
        };
      };

      packages.x86_64-linux = {
        default = self.nixosConfigurations.academy-city.config.system.build.toplevel;
      };

      devShells =
        let
          mkDevShell = system: nixpkgs.legacyPackages.${system}.mkShell {
            buildInputs = with nixpkgs.legacyPackages.${system}; [
              nixfmt-rfc-style
              nix-tree
              direnv
            ];
          };
        in
        {
          x86_64-linux.default = mkDevShell "x86_64-linux";
          aarch64-darwin.default = mkDevShell "aarch64-darwin";
        };
    };
}

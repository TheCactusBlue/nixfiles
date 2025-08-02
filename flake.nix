{
  description = "Hayley's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl-gtk-on-nix = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      aagl-gtk-on-nix,
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

      packages.x86_64-linux = {
        default = self.nixosConfigurations.academy-city.config.system.build.toplevel;
      };

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          nixfmt-rfc-style
          nix-tree
          direnv
        ];
      };
    };
}

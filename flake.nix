{
  description = "NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      monolit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/tower.nix
          ./configuration.nix
          ./hm/nixos.nix

          # WIP: Flake-y home-manager setup.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.viktor = import ./hm/home.nix;
          }
        ];
      };

      vm-aarch64-utm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hardware/vm-utm.nix
          ./hm/nixos.nix

          # WIP: Flake-y home-manager setup.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.viktor = import ./hm/home.nix;
          }
        ];
      };
    };
  };
}

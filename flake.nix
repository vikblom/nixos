{
  description = "NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hw = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hw }: {
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

      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hw.nixosModules.lenovo-thinkpad-t480

          ./hardware/thinkpad.nix
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

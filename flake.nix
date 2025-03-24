{
  description = "NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = { self, nixpkgs, home-manager, ghostty }: {
    nixosConfigurations = {
      monolit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/tower.nix
          ./configuration.nix
          ./hm/nixos.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.viktor = import ./hm/home.nix;
          }
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
        ];
      };

      vm-aarch64-utm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hardware/vm-utm.nix
          ./configuration.nix
          ./hm/nixos.nix

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

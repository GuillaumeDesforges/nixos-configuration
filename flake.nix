{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.claude-code.url = "github:sadjow/claude-code-nix";
  inputs.claude-code.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      # custom packages
      overlay = import ./overlay.nix;

      # helper function to make NixOS systems with common config
      mkNixosSystem =
        {
          hostname,
          system,
          config,
        }:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            flake-inputs = flake-inputs;
          };
          modules = [
            ./modules
            (
              { ... }:
              {
                networking.hostName = hostname;
              }
            )
            config
          ];
        };
    in
    {
      # if you want to use the custom packages
      overlays.default = overlay;

      # desktops
      nixosConfigurations.tosaka = mkNixosSystem {
        hostname = "tosaka";
        system = "x86_64-linux";
        config = ./hosts/tosaka;
      };

      nixosConfigurations.yor = mkNixosSystem {
        hostname = "yor";
        system = "x86_64-linux";
        config = ./hosts/yor;
      };

      # laptops

      nixosConfigurations.nazuna = mkNixosSystem {
        hostname = "nazuna";
        system = "x86_64-linux";
        config = ./hosts/nazuna;
      };

      nixosConfigurations.echidna = mkNixosSystem {
        hostname = "echidna";
        system = "x86_64-linux";
        config = ./hosts/echidna;
      };

      legacyPackages.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend overlay;
    };
}

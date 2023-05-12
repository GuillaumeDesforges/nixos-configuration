{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { nixpkgs, ... }@flake-inputs:
    let
      mkNixosSystem = hostname: system: config:
        nixpkgs.lib.nixosSystem {
          system = system;
          # pkgs = nixpkgs.legacyPackages.${system};
          specialArgs = { inherit flake-inputs; };
          modules = [
            ./machine.nix
            ({ ... }: {
              networking.hostName = hostname;
            })
            config
          ];
        };
    in
    {
      nixosConfigurations.kaguya = mkNixosSystem "kaguya" "x86_64-linux"
        ({ ... }: {
          gdforj = {
            enable = true;
            wsl.enable = true;
          };
        });
      nixosConfigurations.tosaka = mkNixosSystem "tosaka" "x86_64-linux" (
        { ... }: {
          imports = [ ./hardwares/tosaka.nix ];
          gdforj = {
            enable = true;
            desktop.enable = true;
          };
          console.keyMap = "fr";
          services.xserver.layout = "fr";
        }
      );
      nixosConfigurations.yor = mkNixosSystem "yor" "x86_64-linux" (
        { ... }: {
          imports = [ ./hardwares/yor.nix ];
          gdforj = {
            enable = true;
            desktop.enable = true;
          };
          console.keyMap = "uk";
          services.xserver.layout = "gb";
        }
      );
      nixosConfigurations.nazuna = mkNixosSystem "nazuna" "x86_64-linux"
        ({ ... }: {
          gdforj = {
            enable = true;
            wsl.enable = true;
          };
        });
    };
}

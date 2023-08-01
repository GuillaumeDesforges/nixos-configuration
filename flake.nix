{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { nixpkgs, ... }@flake-inputs:
    let
      # helper function to make the NixOS system configuration
      mkNixosSystem = hostname: system: config:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit flake-inputs; };
          modules = [
            ./system.nix
            ({ ... }: {
              networking.hostName = hostname;
            })
            config
          ];
        };
    in
    {
      # wsl machines
      nixosConfigurations.kaguya = mkNixosSystem "kaguya" "x86_64-linux"
        ({ ... }: {
          gdforj.wsl.enable = true;
        });
      nixosConfigurations.nazuna = mkNixosSystem "nazuna" "x86_64-linux"
        ({ ... }: {
          gdforj.wsl.enable = true;
        });
      # desktops
      nixosConfigurations.tosaka = mkNixosSystem "tosaka" "x86_64-linux" (
        { ... }: {
          imports = [ ./hardwares/tosaka.nix ];
          gdforj.desktop.enable = true;
          gdforj.user.music-apps.enable = true;
          gdforj.user.video-apps.enable = true;
        }
      );
      nixosConfigurations.yor = mkNixosSystem "yor" "x86_64-linux" (
        { ... }: {
          imports = [ ./hardwares/yor.nix ];
          gdforj.desktop.enable = true;
          # override keymap
          console.keyMap = "uk";
          services.xserver.layout = "gb";
        }
      );
    };
}

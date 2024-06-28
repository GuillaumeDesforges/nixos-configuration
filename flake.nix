{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixos-generators.url = "github:nix-community/nixos-generators";
  inputs.nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, ... }@flake-inputs:
    let
      # helper function to make the NixOS system configuration
      mkNixosSystem = hostname: system: config:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit flake-inputs; };
          modules = [
            ./system.nix
            ({ ... }: { networking.hostName = hostname; })
            config
          ];
        };
    in {
      # wsl machines
      nixosConfigurations.kaguya = mkNixosSystem "kaguya" "x86_64-linux"
        ({ ... }: { gdforj.wsl.enable = true; });
      # desktops
      nixosConfigurations.tosaka = mkNixosSystem "tosaka" "x86_64-linux"
        ({ ... }: {
          imports = [ ./hardwares/tosaka.nix ];
          gdforj.desktop.enable = true;
          gdforj.user.music-apps.enable = true;
          gdforj.user.video-apps.enable = true;
        });
      nixosConfigurations.yor = mkNixosSystem "yor" "x86_64-linux"
        ({ lib, ... }: {
          imports = [ ./hardwares/yor.nix ];
          gdforj.desktop.enable = true;
          # override keymap
          services.xserver.layout = lib.mkForce "gb";
        });
      # laptop
      nixosConfigurations.nazuna = mkNixosSystem "nazuna" "x86_64-linux"
        ({ ... }: {
          imports = [ ./hardwares/nazuna.nix ];
          gdforj.desktop.enable = true;
          gdforj.user.music-apps.enable = true;
          gdforj.user.gamedev-apps.enable = true;
        });
      # laptops
      nixosConfigurations.chizuru = mkNixosSystem "chizuru" "x86_64-linux"
        ({ lib, ... }: {
          imports = [ ./hardwares/chizuru.nix ];
          gdforj.desktop.enable = true;
          # override keymap
          services.xserver.layout = lib.mkForce "us";
        });
    };
}

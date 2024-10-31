{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.05";

  outputs = { nixpkgs, ... }@flake-inputs:
    let
      overlay = final: prev: {
        dbeaver-bin = final.callPackage ./packages/dbeaver { settings = { Xmx = "4096m"; }; };
      };

      # helper function to make the NixOS system configuration
      mkNixosSystem = hostname: system: config:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = { inherit flake-inputs; };
          modules = [
            ./system.nix
            ({ ... }: { nixpkgs.overlays = [ overlay ]; })
            ({ ... }: { networking.hostName = hostname; })
            config
          ];
        };
    in
    {
      overlay = overlay;
      packages.x86_64-linux = {
        dbeaver = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/dbeaver { };
      };
      # desktops
      nixosConfigurations.tosaka = mkNixosSystem "tosaka" "x86_64-linux"
        ({ ... }: {
          imports = [ ./hardwares/tosaka.nix ];
          gdforj.desktop.enable = true;
          gdforj.user.music-apps.enable = true;
          gdforj.user.video-apps.enable = true;
          gdforj.user.work-apps.enable = true;
          # minecraft
          networking.firewall = {
            allowedTCPPorts = [ 25565 ];
            allowedUDPPorts = [ 25565 ];
          };
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
          gdforj.user.work-apps.enable = true;
        });
    };
}

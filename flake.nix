{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      # custom packages
      overlay = final: prev: {
        dbeaver-bin = final.callPackage ./packages/dbeaver { override_xmx = "4096m"; };
        hcp = final.callPackage ./packages/hcp { };
      };

      # helper function to make NixOS systems with common config
      mkNixosSystem =
        {
          nixpkgs ? flake-inputs.nixpkgs,
          home-manager ? flake-inputs.home-manager,
          hostname,
          system,
          config,
        }:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            flake-inputs = {
              inherit home-manager;
            };
          };
          modules = [
            ./system.nix
            ./desktop.nix
            ./user.nix
            (
              { ... }:
              {
                # shared config
                gdforj.nixpkgs.rev = nixpkgs.sourceInfo.rev;
                gdforj.user.enable = true;
                nixpkgs.overlays = [ overlay ];
                networking.hostName = hostname;
              }
            )
            config
          ];
        };
    in
    {
      # if you want to use the custom packages
      overlay = overlay;

      packages.x86_64-linux.hcp =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.callPackage ./packages/hcp { };

      # desktops
      nixosConfigurations.tosaka = mkNixosSystem {
        hostname = "tosaka";
        system = "x86_64-linux";
        config = (
          { ... }:
          {
            imports = [ ./hardwares/tosaka.nix ];
            gdforj.desktop.enable = true;
            gdforj.user.apps.desktop.enable = true;
            gdforj.user.apps.work.enable = true;
            gdforj.user.apps.gaming.enable = true;
            gdforj.user.apps.music.enable = true;
          }
        );
      };

      nixosConfigurations.yor = mkNixosSystem {
        hostname = "yor";
        system = "x86_64-linux";
        config = (
          { lib, ... }:
          {
            imports = [ ./hardwares/yor.nix ];
            gdforj.desktop.enable = true;
            gdforj.user.apps.desktop.enable = true;
            # override keymap
            services.xserver.layout = lib.mkForce "gb";
          }
        );
      };

      # laptops

      nixosConfigurations.nazuna = mkNixosSystem {
        hostname = "nazuna";
        system = "x86_64-linux";
        config = (
          { ... }:
          {
            imports = [ ./hardwares/nazuna.nix ];
            gdforj.desktop.enable = true;
            gdforj.user.apps.desktop.enable = true;
            gdforj.user.apps.work.enable = true;
          }
        );
      };

      nixosConfigurations.echidna = mkNixosSystem {
        hostname = "echidna";
        system = "x86_64-linux";
        config = (
          { lib, ... }:
          {
            imports = [ ./hardwares/echidna.nix ];
            gdforj.desktop.enable = true;
            gdforj.user.apps.desktop.enable = true;
            gdforj.user.apps.work.enable = true;
            # override keymap
            services.xserver.layout = lib.mkForce "us";
          }
        );
      };
    };
}

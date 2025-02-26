{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      # custom packages
      overlay = final: prev: {
        aider-chat = prev.callPackage ./packages/aider-chat { };
        code-cursor = final.callPackage ./packages/code-cursor { };
        dbeaver-bin = prev.dbeaver-bin.override { override_xmx = "4096m"; };
        exhaustruct = prev.callPackage ./packages/exhaustruct { };
        hcp = final.callPackage ./packages/hcp { };
        sqlc = prev.sqlc.overrideAttrs (old: {
          version = "1.28.0";
          src = final.fetchFromGitHub {
            owner = "sqlc-dev";
            repo = "sqlc";
            rev = "v1.28.0";
            hash = "sha256-kACZusfwEIO78OooNGMXCXQO5iPYddmsHCsbJ3wkRQs=";
          };
          vendorHash = "sha256-5KVCG92aWVx2J78whEwhEhqsRNlw4xSdIPbSqYM+1QI=";
        });
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

      legacyPackages.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend overlay;
    };
}

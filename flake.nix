{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/368ab95c5a5207fb8ee7a6fc6e832dd938a13b9e";
  inputs.home-manager.url = "github:nix-community/home-manager/4e12151c9e014e2449e0beca2c0e9534b96a26b4";

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      # custom packages
      overlay = import ./overlay.nix;

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
            flake-inputs = flake-inputs;
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
            gdforj.user.apps.gaming.enable = true;
            gdforj.user.apps.work.enable = false;
            gdforj.user.apps.music.enable = false;
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
            services.xserver.xkb.layout = lib.mkForce "gb";
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
            # verride keymap documentation
            services.xserver.xkb.layout = lib.mkForce "us";
          }
        );
      };

      legacyPackages.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend overlay;
    };
}

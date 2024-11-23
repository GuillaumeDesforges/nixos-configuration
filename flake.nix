{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.05";

  inputs.nixpkgs-master.url = "github:nixos/nixpkgs/e4735dbdda8288aef24141f3ae8848a14f06fe08";
  inputs.home-manager-master.url = "github:nix-community/home-manager/e83414058edd339148dc142a8437edb9450574c8";

  inputs."nixpkgs-24.11".url = "github:nixos/nixpkgs/release-24.05";

  outputs =
    { nixpkgs, ... }@flake-inputs:
    let
      # custom packages
      overlay = final: prev: {
        dbeaver-bin = final.callPackage ./packages/dbeaver { override_xmx = "4096m"; };
      };

      # helper function to make NixOS systems with common config
      mkNixosSystem =
        { nixpkgs ? flake-inputs.nixpkgs
        , home-manager ? flake-inputs.home-manager
        , hostname
        , system
        , config
        ,
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
                gdforj.nixpkgs.rev = nixpkgs.sourceInfo.rev;
              }
            )
            (
              { ... }:
              {
                gdforj.user.enable = true;
              }
            )
            (
              { ... }:
              {
                nixpkgs.overlays = [ overlay ];
              }
            )
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
      overlay = overlay;

      # desktops
      nixosConfigurations.tosaka = mkNixosSystem {
        hostname = "tosaka";
        system = "x86_64-linux";
        nixpkgs = flake-inputs.nixpkgs-master;
        home-manager = flake-inputs.home-manager-master;
        config = (
          { ... }:
          {
            imports = [ ./hardwares/tosaka.nix ];
            gdforj.desktop.enable = true;
            gdforj.user.apps.desktop.enable = true;
            gdforj.user.apps.work.enable = true;
            gdforj.user.apps.gaming.enable = true;
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
        nixpkgs = flake-inputs."nixpkgs-24.11";
        home-manager = flake-inputs.home-manager-master;
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

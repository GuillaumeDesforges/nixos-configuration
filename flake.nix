{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { nixpkgs, self, ... }@flake-inputs: {
    overlays.default = import ./overlay.nix;
    nixosConfigurations.kaguya = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      specialArgs = { inherit flake-inputs; };
      modules = [
        ./machine.nix
        ({ ... }: {
          networking.hostName = "kaguya";
          gdforj = {
            enable = true;
            wsl.enable = true;
          };
        })
      ];
    };
  };
}

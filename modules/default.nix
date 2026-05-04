{ flake-inputs, ... }:
{
  imports = [
    ./system.nix
    ./desktop.nix
    ./user.nix
    ./claude.nix
  ];

  nixpkgs.overlays = [ flake-inputs.self.overlays.default ];
}

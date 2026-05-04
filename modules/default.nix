{ flake-inputs, ... }:
{
  imports = [
    ./system.nix
    ./desktop
    ./user.nix
    ./apps
    ./claude.nix
  ];

  nixpkgs.overlays = [ flake-inputs.self.overlays.default ];
}

{ flake-inputs, ... }:
{
  imports = [
    ./system.nix
    ./desktop
    ./user.nix
    ./apps
    ./claude.nix
    ./docker.nix
  ];

  nixpkgs.overlays = [ flake-inputs.self.overlays.default ];
}

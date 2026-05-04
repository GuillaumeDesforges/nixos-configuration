{ flake-inputs, ... }:
{
  imports = [
    ./system.nix
    ./desktop
    ./user.nix
    ./apps
    ./docker.nix
  ];

  nixpkgs.overlays = [ flake-inputs.self.overlays.default ];
}

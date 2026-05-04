{ flake-inputs, ... }:
{
  imports = [
    ./system.nix
    ./desktop.nix
    ./user.nix
    ./claude.nix
  ];

  gdforj.user.enable = true;

  nixpkgs.overlays = [ flake-inputs.self.overlays.default ];
}

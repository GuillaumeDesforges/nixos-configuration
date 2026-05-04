{ ... }:
{
  imports = [
    ./system.nix
    ./desktop.nix
    ./user.nix
    ./claude.nix
  ];

  gdforj.user.enable = true;

  nixpkgs.overlays = [ (import ../overlay.nix) ];
}

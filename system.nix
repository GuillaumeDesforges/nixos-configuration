{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.gdforj;
in
{
  imports = [
    ./desktop.nix
    ./wsl.nix
    ./user.nix
  ];

  config = {
    # don't edit
    system.stateVersion = "23.05";

    # Nix system configuration
    nix = {
      # use the same <nixpkgs> flake/channel as NixOS
      registry.nixpkgs.from = { type = "indirect"; id = "nixpkgs"; };
      registry.nixpkgs.to = {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        rev = flake-inputs.nixpkgs.sourceInfo.rev;
      };
      # system-wide Nix settings
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        bash-prompt-prefix = "[] ";
      };
    };
    # system-wide nixpkgs settings
    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = true;
    };

    # use the Hack font
    fonts.fonts = with pkgs; [ hack-font ];

    # default keymap
    console.keyMap = "fr";
    services.xserver.layout = "fr";

    # enable my user by default
    gdforj.user.enable = true;
  };
}

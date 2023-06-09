{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj;
in
{
  imports = [
    ./desktop.nix
    ./wsl.nix
    ./user.nix
  ];

  options.gdforj = {
    enable = mkEnableOption "gdforj NixOS configuration";
  };

  config = mkIf cfg.enable {
    system.stateVersion = "23.05";

    nix = {
      registry.nixpkgs.from = { type = "indirect"; id = "nixpkgs"; };
      registry.nixpkgs.to = {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        rev = flake-inputs.nixpkgs.sourceInfo.rev;
      };
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        bash-prompt-prefix = "[] ";
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = true;
    };

    programs.nix-ld.enable = true;

    fonts.fonts = with pkgs; [ hack-font ];

    gdforj.user.enable = true;
  };
}

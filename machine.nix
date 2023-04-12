{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.gdforj;
in {
  imports = [
    flake-inputs.nixos-wsl.nixosModules.wsl
    ./user.nix
  ];

  options.gdforj = {
    enable = mkEnableOption "gdforj NixOS configuration"; 
    wsl = {
      enable = mkEnableOption "Enable if system is on WSL";
    };
  };

  config = mkIf cfg.enable {
    system.stateVersion = "23.05";

    wsl = mkIf cfg.wsl.enable {
      enable = true;
      defaultUser = "gdforj";

      # https://github.com/nix-community/NixOS-WSL/issues/185
      nativeSystemd = true;
      docker-desktop.enable = true;
    };

    nix = {
      registry.nixpkgs.flake = flake-inputs.nixpkgs;
      package = pkgs.nixUnstable;
      settings = {
        experimental-features = ["nix-command" "flakes"];
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

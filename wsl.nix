{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.wsl;
in {
  imports = [ flake-inputs.nixos-wsl.nixosModules.wsl ];

  options.gdforj.wsl = {
    enable = mkEnableOption "Enable if system is on WSL";
  };

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = "gdforj";

      # https://github.com/nix-community/NixOS-WSL/issues/185
      nativeSystemd = true;
      docker-desktop.enable = true;
    };
  };
}

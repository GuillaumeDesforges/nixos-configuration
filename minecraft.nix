{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.gdforj.minecraft-server;
in
{
  imports = [ ];

  options.gdforj.minecraft-server = {
    enable = mkEnableOption "Enable to host Minecraft. Does not include the Minecraft server itself.";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 25565 ];
    };
  };
}

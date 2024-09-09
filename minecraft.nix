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

    services.cron = {
      enable = true;
      systemCronJobs = [
        "0 19 * * * gdforj (cd /var/lib/minecraft/bpc-revival/ && nix shell nixpkgs#openjdk --command java -Xmx1024M -Xms1024M -jar minecraft_server.1.21.1.jar nogui)"
        "0 23 * * * gdforj (cd /var/lib/minecraft/bpc-revival/ && nix shell nixpkgs#rcon --command rcon -H localhost -p $(cat server.properties | grep 'rcon.port' | cut -c 11-) -P $(cat server.properties | grep 'rcon.password' | cut -c 15-) stop)"
      ];
    };
  };
}

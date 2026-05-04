{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.docker;
in
{
  options.gdforj.docker.enable = mkEnableOption "Docker daemon and CLI";

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = [ pkgs.docker-compose ];
    users.users.gdforj.extraGroups = [ "docker" ];
  };
}

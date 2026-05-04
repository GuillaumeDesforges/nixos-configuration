{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.gamedev;
in
{
  options.gdforj.user.apps.gamedev.enable = mkEnableOption "install gamedev apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj.home.packages = with pkgs; [
      godot_4
    ];
  };
}

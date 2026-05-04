{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.gaming;
in
{
  options.gdforj.user.apps.gaming.enable = mkEnableOption "install gaming apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj.home.packages = with pkgs; [
      steam
      lutris
      prismlauncher
    ];
  };
}

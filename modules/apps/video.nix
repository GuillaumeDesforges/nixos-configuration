{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.video;
in
{
  options.gdforj.user.apps.video.enable = mkEnableOption "install video apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj.home.packages = with pkgs; [
      (wrapOBS {
        plugins = [
          # obs-studio-plugins.obs-backgroundremoval
        ];
      })
    ];
  };
}

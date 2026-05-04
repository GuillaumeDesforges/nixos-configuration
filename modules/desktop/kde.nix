{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.gdforj.desktop.kde;
in
{
  options.gdforj.desktop.kde.enable = mkOption {
    type = types.bool;
    default = config.gdforj.desktop.enable;
    description = "Enable KDE Plasma 6 desktop environment.";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
    xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };
}

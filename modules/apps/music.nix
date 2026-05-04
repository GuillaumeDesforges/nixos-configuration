{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.music;
in
{
  options.gdforj.user.apps.music.enable = mkEnableOption "install music apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj = {
      home.packages = with pkgs; [
        alsa-utils
        audacity
        bitwig-studio5

        # # OSS music
        # guitarix
        # ardour
        # distrho
      ];

      home.sessionVariables.LV2_PATH = lib.strings.concatMapStringsSep ":" (p: "${p}/lib/lv2") [
        pkgs.lsp-plugins
        # pkgs.drumgizmo
        # pkgs.guitarix
        # pkgs.distrho # broken
      ];
    };
  };
}

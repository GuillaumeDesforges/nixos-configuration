{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.desktop;
in
{
  options.gdforj.user.apps.desktop.enable = mkEnableOption "install desktop apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj = {
      home.packages = with pkgs; [
        # web
        google-chrome

        # office & productivity
        libreoffice
        simple-scan

        # multimedia
        vlc
        # FIXME: takes too long to build; custom opencv?
        # gimp
      ];

      programs.kitty = {
        enable = true;
        font = {
          name = "Hack Nerd Font Mono";
          size = 18;
        };
        keybindings = {
          "ctrl+shift+enter" = "new_window_with_cwd";
          "ctrl+shift+t" = "new_tab_with_cwd";
        };
      };
    };
  };
}

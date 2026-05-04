{ ... }:
{
  imports = [ ./hardware.nix ];

  gdforj.desktop.enable = true;
  gdforj.user.apps.desktop.enable = true;
  gdforj.user.apps.gaming.enable = true;
  gdforj.user.apps.work.enable = true;
  gdforj.user.apps.dev.enable = true;
  gdforj.user.apps.music.enable = true;
  gdforj.claude.enable = true;
}

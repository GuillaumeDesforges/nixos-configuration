{ ... }:
{
  imports = [ ./hardware.nix ];

  gdforj.desktop.enable = true;
  gdforj.user.apps.desktop.enable = true;
  gdforj.user.apps.work.enable = true;
}

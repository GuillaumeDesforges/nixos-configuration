{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.gdforj.desktop.printing;
in
{
  options.gdforj.desktop.printing.enable = mkOption {
    type = types.bool;
    default = config.gdforj.desktop.enable;
    description = "Enable CUPS printing, SANE scanning, and Avahi mDNS for printer discovery.";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [
      # HP
      pkgs.hplip
      # Canon
      pkgs.cnijfilter2
      # Epson
      pkgs.epson-escpr
    ];
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.sane-airscan ];
    services.udev.packages = [ pkgs.sane-airscan ];
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
  };
}

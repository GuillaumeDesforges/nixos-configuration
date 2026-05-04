{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.desktop;
in
{
  imports = [
    ./audio.nix
    ./printing.nix
    ./kde.nix
    ./zsa.nix
  ];

  options.gdforj.desktop.enable = mkEnableOption "Enable if system is a desktop";

  config = mkIf cfg.enable {
    # enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    # SDDM display manager with autologin
    services.displayManager.sddm.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = config.gdforj.user.name;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    environment.systemPackages = [
      # Clipboard utility, necessary for nvim
      pkgs.xclip
    ];

    # Fix xdg-open
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
    };
  };
}

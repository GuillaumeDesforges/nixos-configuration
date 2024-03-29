{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types;
  cfg = config.gdforj.desktop;
in
{
  imports = [ ];

  options.gdforj.desktop = {
    enable = mkEnableOption "Enable if system is a desktop";
  };

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

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = [
      # HP
      pkgs.hplip
      # Canon
      pkgs.cnijfilter2
    ];

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Enable automatic login for the user
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = "gdforj";

    # Install desktop apps by default
    gdforj.user.desktop-apps.enable = true;

    # install Docker
    virtualisation.docker.enable = true;
    virtualisation.docker.enableNvidia = true;

    # OpenGL
    hardware.opengl.driSupport32Bit = true;

    # System packages for desktop
    environment.systemPackages = [
      # Clipboard utility, necessary for nvim
      pkgs.xclip
      # Docker
      pkgs.docker-compose
    ];
  };
}


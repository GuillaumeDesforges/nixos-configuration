{ lib, config, flake-inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
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
    # enable WEP key
    nixpkgs.overlays = [
      (self: super: {
        wpa_supplicant = super.wpa_supplicant.overrideAttrs (oldAttrs: rec {
          extraConfig = oldAttrs.extraConfig + ''
            CONFIG_WEP=y
          '';
        });
      })
    ];

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
    sound.enable = false;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable SSDM display manager
    services.displayManager.sddm.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "gdforj";

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.desktopManager.plasma5.enable = true;

    # Install desktop apps by default
    gdforj.user.desktop-apps.enable = true;

    # install Docker
    virtualisation.docker.enable = true;

    # System packages for desktop
    environment.systemPackages = [
      # Clipboard utility, necessary for nvim
      pkgs.xclip
      # Docker
      pkgs.docker-compose
    ];
  };
}


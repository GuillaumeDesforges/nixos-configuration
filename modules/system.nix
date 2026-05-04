{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.gdforj.system;
in
{
  options.gdforj.system = {
    keyboardLayout = mkOption {
      type = types.str;
      default = "fr";
      description = "X11/console keyboard layout (xkb).";
    };
  };

  config = {
    # don't edit
    system.stateVersion = "23.05";

    # Nix system configuration
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        bash-prompt-prefix = "[] ";
        flake-registry = "";
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
      # nixpkgs.config.cudaSupport should be enabled per machine;
    };
    nixpkgs.flake.setNixPath = true;
    nixpkgs.flake.setFlakeRegistry = true;

    # use the Hack font
    fonts.packages = [
      pkgs.nerd-fonts.hack
    ];

    services.xserver.xkb.layout = cfg.keyboardLayout;
    services.xserver.xkb.options = "caps:escape";
    console.useXkbConfig = true;

    # allow proper DNS resolution
    services.resolved.enable = true;

    # essential utils
    environment.systemPackages = [
      # sysadmin
      pkgs.binutils
      pkgs.xxd
      pkgs.file
      pkgs.wget
      pkgs.zip
      pkgs.unzip
      pkgs.htop
      pkgs.tree
      pkgs.tmux
    ];

    # run arbitrary binaries
    programs.nix-ld.enable = true;
  };
}

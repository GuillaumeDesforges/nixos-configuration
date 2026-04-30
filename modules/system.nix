{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption;
in
{
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
        bash-prompt-prefix = "[] ";
        flake-registry = "";
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
      flake.setNixPath = true;
      flake.setFlakeRegistry = true;
      # nixpkgs.config.cudaSupport should be enabled per machine;
    };

    # use the Hack font
    fonts.packages = [
      pkgs.nerd-fonts.hack
    ];
    console.font = "HackNerdFontMono";

    # default keymap
    services.xserver.xkb.layout = "fr";
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

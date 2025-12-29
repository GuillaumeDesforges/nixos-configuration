{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkIf;
  cfg = config.gdforj;
in
{
  options.gdforj.nixpkgs.rev = mkOption {
    default = "";
    type = lib.types.str;
  };

  config.assertions = [
    {
      assertion = config.gdforj.nixpkgs.rev != "";
      message = "Missing config `gdforj.nixpkgs.rev`";
    }
  ];

  config = {
    # don't edit
    system.stateVersion = "23.05";

    # Nix system configuration
    nix = {
      # use the same <nixpkgs> flake/channel as NixOS
      registry.nixpkgs.from = {
        type = "indirect";
        id = "nixpkgs";
      };
      registry.nixpkgs.to = {
        type = "github";
        owner = "nixos";
        repo = "nixpkgs";
        rev = config.gdforj.nixpkgs.rev;
      };
      # system-wide Nix settings
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        bash-prompt-prefix = "[] ";
        flake-registry = "";
      };
    };
    # system-wide nixpkgs settings
    nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = true;
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

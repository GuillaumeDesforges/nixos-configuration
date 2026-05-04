{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.claude;
in
{
  options.gdforj.user.apps.claude.enable =
    mkEnableOption "Install Claude Code from sadjow/claude-code-nix";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ flake-inputs.claude-code.overlays.default ];
    home-manager.users.gdforj.home.packages = [ pkgs.claude-code ];
  };
}

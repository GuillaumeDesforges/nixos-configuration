{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.gdforj.claude;
in
{
  imports = [ ];

  options.gdforj.claude = {
    enable = mkEnableOption "Install Claude Code from sadjow/claude-code-nix";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ flake-inputs.claude-code.overlays.default ];
    environment.systemPackages = [ pkgs.claude-code-bun ];
  };
}

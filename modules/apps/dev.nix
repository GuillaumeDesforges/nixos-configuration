{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.dev;
in
{
  options.gdforj.user.apps.dev.enable = mkEnableOption "install dev apps";

  config = mkIf cfg.enable {
    home-manager.users.gdforj = {
      home.packages =
        with pkgs;
        [
          # dev tools
          gnumake
          ripgrep
          lazygit

          # data processing
          jq
          jc
          yq-go
          jless

          # cloud
          (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.cloud_sql_proxy ])
          gh
        ]
        ++ lib.optionals config.gdforj.user.apps.desktop.enable [
          dbeaver-bin
        ];

      programs.bash.shellAliases.ppjson = "jq -R -r '. as $line | try fromjson catch $line'";
    };
  };
}

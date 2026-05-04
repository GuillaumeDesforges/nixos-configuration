{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user.apps.work;
in
{
  options.gdforj.user.apps.work.enable = mkEnableOption "install work apps";

  config = mkIf cfg.enable {
    home-manager.users.${config.gdforj.user.name} = {
      home.packages =
        with pkgs;
        [
          # ops
          envsubst
          gnumake
          just
          mage
          pre-commit
          temporal-cli
          # infra
          awscli2
          kubectl
          kubernetes-helm
          terraform
          # security
          trivy
          gitleaks
          ssm-session-manager-plugin
          # data
          flyway
          postgresql
          # golang
          air
          delve
          exhaustruct
          go
          golangci-lint
          gopls
          sqlc
          templ
          # javascript
          nodejs_latest
          pnpm
          # runtime deps
          poppler-utils
        ]
        ++ lib.optionals config.gdforj.user.apps.desktop.enable [
          # social
          slack
        ];

      programs.neovim.extraPackages = with pkgs; [
        # golang
        gopls
        golangci-lint-langserver
        # hcl
        terraform-ls
        # HTML, CSS, JSON, ESLint
        vscode-langservers-extracted
        # javascript/typescript
        prettierd
      ];
    };
  };
}

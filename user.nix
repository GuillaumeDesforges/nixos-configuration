{
  lib,
  config,
  flake-inputs,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user;
in
{
  imports = [ flake-inputs.home-manager.nixosModules.home-manager ];

  options.gdforj.user = {
    enable = mkEnableOption "gdforj user";
    apps.desktop.enable = mkEnableOption "install desktop apps";
    apps.dev.enable = mkEnableOption "install dev apps";
    apps.gamedev.enable = mkEnableOption "install gamedev apps";
    apps.gaming.enable = mkEnableOption "install gaming apps";
    apps.music.enable = mkEnableOption "install music apps";
    apps.video.enable = mkEnableOption "install video apps";
    apps.work.enable = mkEnableOption "install work apps";
  };

  config = mkIf cfg.enable {
    users.users.gdforj = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "lp"
        "scanner"
        "plugdev"
        "wheel"
      ];
      initialPassword = "password";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.gdforj =
      { pkgs, ... }:
      {
        home.stateVersion = "22.11";
        programs.home-manager.enable = true;

        xdg.configFile."nixpkgs/config.nix".text = ''
          { allowUnfree = true; }
        '';
        # # overriden by useGlobalPkgs
        # nixpkgs.config.allowUnfree = true;

        fonts.fontconfig.enable = true;

        home.sessionPath = [ "$HOME/.gdforj/bin" ];
        home.packages =
          with pkgs;
          # common
          [
            # Nix utils
            nixpkgs-fmt
            nixpkgs-review
            nix-index
            nix-tree
            nix-output-monitor
            nixfmt-rfc-style
          ]
          ++ pkgs.lib.optionals cfg.apps.dev.enable [
            # dev tools
            gnumake
            ripgrep
            lazygit
            aider-chat

            # data processing
            jq
            jc
            yq-go
            jless

            # cloud
            (pkgs.google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.cloud_sql_proxy ])
            gh
          ]
          # desktop
          ++ pkgs.lib.optionals cfg.apps.desktop.enable (
            [
              # fonts, to be used in terminal emulators
              nerd-fonts.hack

              # web
              google-chrome

              # office & productivity
              # libreoffice
              simple-scan

              # multimedia
              vlc
              # FIXME: takes too long to build; custom opencv?
              # gimp
            ]
            # work on desktop
            ++ pkgs.lib.optionals cfg.apps.work.enable [
              # social
              slack
            ]
            # dev on desktop
            ++ pkgs.lib.optionals cfg.apps.dev.enable [
              # dev
              vscode-fhs
              code-cursor
              dbeaver-bin
            ]
          )
          # work
          ++ pkgs.lib.optionals cfg.apps.work.enable [
            # ops
            envsubst
            gnumake
            just
            mage
            # devops
            pre-commit
            # cloud
            awscli2
            hcp
            heroku
            temporal-cli
            # infra
            kubectl
            kubernetes-helm
            terraform
            # secrets
            sops
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
            poppler_utils
          ]
          # music
          ++ pkgs.lib.optionals cfg.apps.music.enable [
            alsa-utils
            audacity
            bitwig-studio5

            # # OSS music
            # guitarix
            # ardour
            # distrho
          ]
          # streaming/recording
          ++ pkgs.lib.optionals cfg.apps.video.enable [
            (wrapOBS {
              plugins = [
                # obs-studio-plugins.obs-backgroundremoval
              ];
            })
          ]
          # gaming
          ++ pkgs.lib.optionals cfg.apps.gaming.enable [
            steam
            lutris
            prismlauncher
          ]
          # gamedev
          ++ pkgs.lib.optionals cfg.apps.gamedev.enable [ godot_4 ];

        programs.bash = {
          enable = true;
          bashrcExtra = ''
            # get history on new shell
            shopt -s histappend
            PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
          '';
          initExtra = ''
            # set prompt
            export PS1="\u@\h:\W\$ "
          '';
          shellAliases =
            {
              "tmpdir" = "cd $(mktemp -d)";
            }
            // (mkIf cfg.apps.desktop.enable {
              "google-chrome" = "google-chrome-stable";
            });
        };
        programs.fzf.enable = true;

        programs.neovim = {
          enable = true;
          vimAlias = true;
          # add programs needed for plugins
          withNodeJs = true;
          plugins = with pkgs.vimPlugins; [
            lazy-nvim
          ];
          extraPackages = [
            # needed for lazyvim
            pkgs.ripgrep
            pkgs.lazygit
            # needed to install some plugins
            pkgs.gcc
            pkgs.gnumake
            # user LSPs (others must be provided per-project)
            pkgs.lua-language-server # lua
            pkgs.nixd # nix
            pkgs.terraform-ls # hcl
            pkgs.gopls # golang
            pkgs.golangci-lint-langserver # golang linters
            pkgs.zls # zig
            pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
            pkgs.jdt-language-server # java
          ];

          # lua config is handled manually by linking files from
          # https://github.com/GuillaumeDesforges/dotfiles
          # manually to ~/.config/neovim
        };

        programs.git = {
          enable = true;
          lfs.enable = true;

          userEmail = "guillaume.desforges.pro@gmail.com";
          userName = "Guillaume Desforges";

          extraConfig = {
            core = {
              editor = "vim";
            };
            pull = {
              ff = "only";
            };
          };

          aliases = {
            prune-branches = "!git fetch -p && for b in $(git for-each-ref --format='''%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)''' refs/heads); do git branch -D $b; done";
            graph = "log --graph --all --oneline";
          };
        };

        programs.kitty = mkIf cfg.apps.desktop.enable {
          enable = true;
          font = {
            name = "HackNerdMono";
            size = 18;
          };
          keybindings = {
            "ctrl+shift+enter" = "new_window_with_cwd";
            "ctrl+shift+t" = "new_tab_with_cwd";
          };
        };

        home.sessionVariables =
          {
            EDITOR = "vim";
          }
          // (
            if cfg.apps.music.enable then
              {
                LV2_PATH = lib.strings.concatMapStringsSep ":" (p: "${p}/lib/lv2") [
                  pkgs.lsp-plugins
                  # pkgs.drumgizmo
                  # pkgs.guitarix
                  # pkgs.distrho # broken
                ];
              }
            else
              { }
          );
      };
  };
}

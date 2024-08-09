{ lib, config, flake-inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user;
in
{
  imports = [ flake-inputs.home-manager.nixosModules.home-manager ];

  options.gdforj.user = {
    enable = mkEnableOption "gdforj user";
    desktop-apps.enable = mkEnableOption "install desktop apps";
    music-apps.enable = mkEnableOption "install music apps";
    video-apps.enable = mkEnableOption "install video apps";
    gamedev-apps.enable = mkEnableOption "install gamedev apps";
  };

  config = mkIf cfg.enable {
    users.users.gdforj = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      initialPassword = "password";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.gdforj = { pkgs, ... }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;

      xdg.configFile."nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
      nixpkgs.config.allowUnfree = true;

      fonts.fontconfig.enable = true;

      home.packages = with pkgs;
        [
          # common sysadmin
          file
          wget
          zip
          unzip
          htop

          # common user tools
          tree
          tmux

          # company tools
          tmate
          cloak

          # Nix utils
          nixpkgs-fmt
          nixpkgs-review
          nix-index
          nix-tree
          nix-output-monitor

          # data processing
          jq
          jc
          yq
          jless

          # cloud
          azure-cli
          (pkgs.google-cloud-sdk.withExtraComponents
            [ pkgs.google-cloud-sdk.components.cloud_sql_proxy ])
          awscli2
          terraform
          kubectl
          kubernetes-helm

          # SaaS
          gh
        ]
        # desktop
        ++ pkgs.lib.optionals cfg.desktop-apps.enable [
          # fonts, to be used in terminal emulators
          (nerdfonts.override { fonts = [ "Hack" ]; })

          # web
          google-chrome

          # social
          slack
          element-desktop

          # office
          libreoffice

          # productivity
          obsidian

          # multimedia
          vlc
          gimp
          stremio

          # dev
          vscode-fhs
          dbeaver-bin

          # gaming
          steam
          lutris
        ]
        # music
        ++ pkgs.lib.optionals cfg.music-apps.enable [
          alsa-utils
          audacity
          guitarix

          bitwig-studio5

          # OSS music
          # ardour
          # distrho
        ]
        # streaming/recording
        ++ pkgs.lib.optionals cfg.video-apps.enable [
          (wrapOBS {
            plugins = [
              #
              # obs-studio-plugins.obs-backgroundremoval 
            ];
          })
        ]
        # gamedev
        ++ pkgs.lib.optionals cfg.gamedev-apps.enable [
          # Godot
          godot_4
        ];

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
        shellAliases = {
          "tmpdir" = "cd $(mktemp -d)";
        } // (mkIf cfg.desktop-apps.enable {
          "google-chrome" = "google-chrome-stable";
        });
      };
      programs.fzf.enable = true;

      programs.neovim = {
        enable = true;
        vimAlias = true;
        # add programs needed for plugins
        extraPackages = [
          # needed for lazyvim
          pkgs.ripgrep
          pkgs.lazygit
          # needed to install some plugins
          pkgs.gcc
          pkgs.gnumake
          # needed for Copilot
          pkgs.nodejs_latest
          # user LSPs (others must be provided per-project)
          pkgs.lua-language-server
          pkgs.nixd
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
          core = { editor = "vim"; };
          pull = { ff = "only"; };
        };

        aliases = {
          prune-branches =
            "!git fetch -p && for b in $(git for-each-ref --format='''%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)''' refs/heads); do git branch -D $b; done";
          graph = "log --graph --all --oneline";
        };
      };

      programs.kitty = mkIf cfg.desktop-apps.enable {
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

      home.sessionVariables = {
        EDITOR = "vim";
      } // (if cfg.music-apps.enable then {
        LV2_PATH =
          "${pkgs.drumgizmo}/lib/lv2/:${pkgs.distrho}/lib/lv2/:${pkgs.guitarix}/lib/lv2/:${pkgs.lsp-plugins}/lib/lv2/";
      } else
        { });
    };
  };
}

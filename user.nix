{ lib, config, flake-inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gdforj.user;
in
{
  imports = [
    flake-inputs.home-manager.nixosModules.home-manager
    ./secrets.nix
  ];

  options.gdforj.user = {
    enable = mkEnableOption "gdforj user";
    desktop-apps.enable = mkEnableOption "install desktop apps";
    music-apps.enable = mkEnableOption "install music apps";
    video-apps.enable = mkEnableOption "install video apps";
  };

  config = mkIf cfg.enable {
    users.users.gdforj = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      initialPassword = "password";
    };

    home-manager.users.gdforj = { pkgs, ... }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;

      nixpkgs.config.allowUnfree = true;

      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        # common sysadmin
        file
        wget
        zip
        unzip
        htop

        # common user tools
        tree
        tmux

        # agenix CLI tool
        flake-inputs.agenix.packages.x86_64-linux.default

        # company tools
        tmate
	cloak

        # common build tools
        gnumake

        # Nix utils
        nixpkgs-fmt
        nixpkgs-review
        nix-index
        nix-tree

        # data processing
        jq
        yq
        jless

        # cloud
        azure-cli
        google-cloud-sdk
        awscli2
        terraform
        kubectl
        kubernetes-helm

        # SaaS
        gh

        # Python
        poetry

        # JS/TS
        yarn
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

        # multimedia
        vlc
        gimp

        # dev
        vscode-fhs
        dbeaver

        # gaming
        steam
      ]
      # music
      ++ pkgs.lib.optionals cfg.music-apps.enable [
        alsa-utils
        audacity
        ardour
        bitwig-studio
        distrho
        guitarix
      ]
      # streaming/recording
      ++ pkgs.lib.optionals cfg.video-apps.enable [
        (wrapOBS { plugins = [ obs-studio-plugins.obs-backgroundremoval ]; })
      ]
      ;

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
          // (mkIf cfg.desktop-apps.enable {
            "google-chrome" = "google-chrome-stable";
          })
        ;
      };
      programs.fzf.enable = true;

      programs.neovim = {
        enable = true;
        vimAlias = true;
        # add programs needed for plugins
        extraPackages = [
          # needed to install things via mason
          pkgs.gcc
          pkgs.cargo
          pkgs.nodejs_latest
          # needed for lazyvim
          pkgs.ripgrep
          pkgs.lazygit
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
          prune-branches = "!git fetch -p && for b in $(git for-each-ref --format='\''%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)'\'' refs/heads); do git branch -D $b; done";
          graph = "log --graph --all --oneline";
        };
      };

      programs.kitty = mkIf cfg.desktop-apps.enable {
        enable = true;
        font = {
          name = "Hack Nerd Font Mono";
          size = 16;
        };
      };

      home.sessionVariables = {
        EDITOR = "vim";
      } // (if cfg.music-apps.enable then {
        LV2_PATH = "${pkgs.drumgizmo}/lib/lv2/:${pkgs.distrho}/lib/lv2/:${pkgs.guitarix}/lib/lv2/:${pkgs.lsp-plugins}/lib/lv2/";
      } else { });
    };
  };
}

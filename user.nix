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
    desktop-apps = {
      enable = mkEnableOption "install desktop apps";
    };
  };

  config = mkIf cfg.enable {
    users.users.gdforj = {
      isNormalUser = true;
      initialHashedPassword = "IBEH7HSCOsr4Y";
      extraGroups = [ "wheel" "docker" ];
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
        terraform
        kubectl
        kubernetes-helm

        # Python
        poetry

        # JS/TS
        yarn
      ]
      # Desktop applications
      ++ pkgs.lib.optionals config.gdforj.user.desktop-apps.enable [
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
        (wrapOBS { plugins = [ obs-studio-plugins.obs-backgroundremoval ]; })

        # music
        alsa-utils
        audacity
        ardour
        distrho

        # gaming & game dev
        steam
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
          # required by ChatGPT.nvim
          export OPENAI_API_KEY="$(cat ${config.age.secrets.openai_key.path})"
        '';
      };
      programs.fzf.enable = true;

      programs.neovim = {
        enable = true;

        vimAlias = true;
        withNodeJs = true;

        coc.enable = true;
        coc.settings = pkgs.lib.recursiveUpdate
          (builtins.fromJSON ''
            {
              "tsserver.useLocalTsdk": true,
              "python.formatting.provider": "black",
              "python.linting.flake8Enabled": true,
              "languageserver": {
                "nix": {
                  "command": "rnix-lsp",
                  "filetypes": ["nix"]
                },
                "terraform": {
                  "command": "terraform-ls",
                  "args": ["serve"],
                  "filetypes": [
                    "terraform",
                    "tf"
                  ],
                  "initializationOptions": {},
                  "settings": {}
                }
              }
            }
          '')
          {
            languageserver.nix.command = "${pkgs.rnix-lsp}/bin/rnix-lsp";
            languageserver.terraform.command = "${pkgs.terraform-ls}/bin/terraform-ls";
            rust-analyzer.server.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };

        extraLuaConfig =
          builtins.readFile ./nvim/init.lua
          + (if config.gdforj.desktop.enable then ''
            -- configure clipboard
            vim.opt.clipboard = 'unnamedplus'
          '' else "");

        plugins = with pkgs.vimPlugins; [
          vim-code-dark # dark color scheme

          sleuth # smart indent size for each buffer

          nvim-web-devicons # requirement for feline
          feline-nvim # status bar

          vim-nix # nix syntax highlighting
          vim-nickel # nickel syntax highlighting
          vim-terraform # terraform syntax highlighting

          coc-tsserver # coc for TS/JS
          coc-pyright # coc for python
          coc-rust-analyzer # coc for rust
          coc-clangd # coc for C

          vim-terraform-completion # terraform autocomplete

          ChatGPT-nvim # chatgpt
          nui-nvim
          plenary-nvim
          telescope-nvim
        ];
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

      programs.vscode = {
        enable = true;
      };

      home.sessionVariables = {
        EDITOR = "vim";
      } // (if config.gdforj.user.desktop-apps.enable then {
        LV2_PATH = "${pkgs.drumgizmo}/lib/lv2/:${pkgs.distrho}/lib/lv2/";
      } else { });
    };
  };
}

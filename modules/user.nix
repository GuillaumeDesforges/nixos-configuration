{
  lib,
  config,
  flake-inputs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.gdforj.user;
in
{
  imports = [ flake-inputs.home-manager.nixosModules.home-manager ];

  options.gdforj.user.name = mkOption {
    type = types.str;
    default = "gdforj";
    description = "Username of the primary user account.";
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      extraGroups = [
        "lp"
        "scanner"
        "plugdev"
        "wheel"
      ];
      initialPassword = "password";
    };

    home-manager.useGlobalPkgs = true;
    home-manager.users.${cfg.name} =
      { pkgs, ... }:
      {
        home.stateVersion = "22.11";
        programs.home-manager.enable = true;

        fonts.fontconfig.enable = true;

        home.sessionPath = [ "$HOME/.${cfg.name}/bin" ];
        home.packages = with pkgs; [
          # Nix utils
          nixpkgs-review
          nix-index
          nix-tree
          nix-output-monitor
          nixfmt
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
          };
        };
        programs.fzf.enable = true;

        programs.neovim = {
          enable = true;
          vimAlias = true;
          # add programs needed for plugins
          withNodeJs = true;
          extraPackages = [
            # rocks.nvim
            pkgs.luajit
            pkgs.luajitPackages.luarocks

            # required to open file from lazygit.nvim
            pkgs.neovim-remote

            # lua
            pkgs.lua-language-server

            # nix
            pkgs.nixd

            # copilot.lua
            pkgs.copilot-language-server
          ];

          # lua config is handled manually by linking files from
          # https://github.com/GuillaumeDesforges/dotfiles
          # manually to ~/.config/neovim
        };

        programs.git = {
          enable = true;
          lfs.enable = true;

          settings = {
            user = {
              email = "guillaume.desforges.pro@gmail.com";
              name = "Guillaume Desforges";
            };

            aliases = {
              prune-branches = "!git fetch -p && for b in $(git for-each-ref --format='''%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)''' refs/heads); do git branch -D $b; done";
              graph = "log --graph --all --oneline";
            };

            extraConfig = {
              core = {
                editor = "vim";
              };
              pull = {
                ff = "only";
              };
            };
          };
        };

        home.sessionVariables = {
          EDITOR = "vim";
        };
      };
  };
}

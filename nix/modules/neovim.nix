# TODO: Revisit the config and prioritise telescope more
{ ... }:
{
  flake.modules.homeManager.neovim =
    { config, pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        extraPackages = with pkgs; [
          clang-tools
          lua-language-server
          nixd
          nixfmt-rfc-style
          ripgrep
          stylua
          wl-clipboard
        ];

        plugins =
          let
            treesitterParsers = pkgs.vimPlugins.nvim-treesitter.withPlugins (
              parser: with parser; [
                bash
                c
                comment
                csv
                desktop
                git_config
                gitignore
                ini
                json
                json5
                ledger
                lua
                luadoc
                luap
                luau
                markdown
                markdown_inline
                nix
                printf
                sway
                tsv
                vim
                vimdoc
                xml
                yaml
                zig
              ]
            );

            mkOptionalPlugin = type: plugin: {
              inherit type plugin;
              optional = true;
            };

            optionalLuaPlugins = builtins.map (p: mkOptionalPlugin "lua" p) (
              with pkgs.vimPlugins;
              [
                blink-cmp
                conform-nvim
                mini-clue
                nvim-autopairs
                oil-nvim
              ]
            );
          in
          with pkgs.vimPlugins;
          [
            lz-n
            mini-icons
            nvim-lspconfig
            onedark-nvim
            treesitterParsers
            vim-ledger
          ]
          ++ optionalLuaPlugins;
      };

      xdg = {
        configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/files/neovim";

        desktopEntries = {
          "nvim" = {
            name = "nvim";
            noDisplay = true;
          };
        };
      };
    };
}

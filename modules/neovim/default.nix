{ config, pkgs, ... }:
let
  codecompanion-nvim-latest = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion-nvim"; version = "2025-08-11";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris"; repo = "codecompanion.nvim";
      rev = "02b5a14926be3d37fbfa19de5e8336db8a5711e6";
      sha256 = "sha256-Z9oXfBJCzg7j61wcegkutPK14cgWfuoQDRLdWq//mJs=";
    };
    buildInputs = [ pkgs.vimPlugins.plenary-nvim ];
    nvimSkipModules = [
      "codecompanion.providers.actions.fzf_lua"
      "codecompanion.providers.actions.mini_pick"
      "codecompanion.providers.actions.snacks"
      "codecompanion.providers.actions.telescope"
      "codecompanion.providers.completion.blink.setup"
      "codecompanion.providers.completion.cmp.setup"
      "minimal"
    ];
  };
  conformNvim = pkgs.vimUtils.buildVimPlugin {
    pname = "conform.nvim"; version = "v1.0.0";
    src = pkgs.fetchFromGitHub { owner = "stevearc"; repo = "conform.nvim"; tag = "v9.0.0"; sha256 = "sha256-H9JLiRtixDKDN50SH6gkqgjlhLzHMAaOT1pc69ZFdco="; };
    dependencies = [ pkgs.vimPlugins.plenary-nvim ];
  };
  fidgetSpinnner = pkgs.vimUtils.buildVimPlugin {
    pname = "fidget-spinner"; src = ./custom-neovim-plugins/fidget-spinner; version = "0.1.0"; dependencies = [ pkgs.vimPlugins.fidget-nvim ];
  };
in {
  home-manager.users.${config.my.user.name}.programs.neovim = {
    enable = true; viAlias = true; vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim nvim-lspconfig nvim-cmp vim-vsnip cmp-nvim-lsp copilot-lua
      plenary-nvim nvim-treesitter.withAllGrammars telescope-nvim telescope-ui-select-nvim
      lualine-nvim nvim-web-devicons which-key-nvim neo-tree-nvim nui-nvim fidget-nvim
      mini-diff indent-blankline-nvim codecompanion-nvim-latest conformNvim fidgetSpinnner
    ];
    extraConfig = ''colorscheme tokyonight-night\nset expandtab\nset nu\nset undofile'';
    extraPackages = with pkgs; [ nodejs nil gcc tree-sitter nodePackages.prettier black pyright nixfmt-rfc-style stylua ];
    extraLuaConfig = builtins.readFile ./nvim-lua-config.lua;
  };
}

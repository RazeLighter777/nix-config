{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.neovim.enable {
    home-manager.users.${config.my.user.name}.programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-cmp
        vim-vsnip
        cmp-nvim-lsp
        plenary-nvim
        nvim-treesitter.withAllGrammars
        telescope-nvim
        telescope-ui-select-nvim
        lualine-nvim
        nvim-web-devicons
        which-key-nvim
        neo-tree-nvim
        nui-nvim
        fidget-nvim
        mini-diff
        indent-blankline-nvim
        conform-nvim
      ];
      extraConfig = ''
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set softtabstop=2
        set nu
        set undofile'';
      extraPackages = with pkgs; [
        nodejs
        nil
        gcc
        tree-sitter
        nodePackages.prettier
        black
        pyright
        nixfmt
        stylua
      ];
      initLua = builtins.readFile ./nvim-lua-config.lua;
    };
  };
}

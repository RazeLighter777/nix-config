{ pkgs, ... }:
{
  home-manager.users.justin.programs.neovim = {
	enable = true;
	viAlias = true;
	vimAlias = true;
	plugins = with pkgs.vimPlugins; [
		vim-nix
		vim-polyglot
		gruvbox
		nvim-lspconfig
		nvim-cmp
		vim-vsnip
		cmp-nvim-lsp
	];
	extraConfig = ''
		colorscheme gruvbox

	'';
	extraLuaConfig = ''
		local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

		vim.diagnostic.config({
			virtual_text = true,  -- show inline messages
			signs = true,         -- show signs in the gutter
			underline = true,     -- underline problematic text
			update_in_insert = true, -- don't update diagnostics while typing
			severity_sort = true,     -- sort diagnostics by severity
		})
		local cmp = require('cmp')
		cmp.setup {
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			sources = cmp.config.sources({
					{ name = 'nvim_lsp'},
					{ name = 'vsnip' }
				},
					{
						{ name = 'buffer' }
					}
			),
			mapping = {
				    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
			      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}
		}
		local capabilties = require('cmp_nvim_lsp').default_capabilities()
		require('lspconfig').rust_analyzer.setup {
			capabilities = capabilities,
			settings = {
				['rust-analyzer'] = {
					diagnostics = {
						enable = true;
					}
				}
			}
		}
	'';
  };
}

{pkgs, ... }:
let
  # Override CopilotChat.nvim to pull from GitHub latest commit
  copilotChatLatest = pkgs.vimUtils.buildVimPlugin {
    pname = "CopilotChat-nvim";
    version = "git-latest";
    src = pkgs.fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      rev = "main"; # you can pin to a commit hash instead of branch
      sha256 = "sha256-/1nXQw0ptKCkt719nKaoZEmR9H9oy2PtPcv+UwejA3s="; # replace with actual hash from nix-prefetch
		};
		dependencies = [
			pkgs.vimPlugins.plenary-nvim
			pkgs.vimPlugins.telescope-nvim
			pkgs.vimPlugins.telescope-ui-select-nvim
		];
	};
in
{
  home-manager.users.justin.programs.neovim = {
	enable = true;
	viAlias = true;
	vimAlias = true;
	plugins = with pkgs.vimPlugins; [
		vim-nix
		vim-polyglot
		onedark-nvim
		nvim-lspconfig
		nvim-cmp
		vim-vsnip
		cmp-nvim-lsp
		copilot-lua
		copilotChatLatest
		plenary-nvim
		nvim-treesitter.withAllGrammars
		telescope-nvim
		telescope-ui-select-nvim
	];
	extraConfig = ''
		colorscheme onedark
		set noexpandtab
	'';
	extraPackages = with pkgs; [
		nodejs
	];
	extraLuaConfig = ''
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end
		local feedkey = function(key, mode)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
		end
		require('telescope').setup {
			extensions = {
				ui_select = {
					require("telescope.themes").get_dropdown {}
				}
			}
		}
		require('telescope').load_extension('ui-select')
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		require('CopilotChat').setup {
			model = "claude-sonnet-4",
			window = {
				layout = 'vertical',
				width = 0.25, -- 25% of the screen width
			},
			auto_insert_mode = true,
		}
		require("copilot").setup {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 64,
				keymap = {
					accept = "<C-f>",
					accept_word = false,
					accept_line = false,
					next = "<M-\\>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				}
			 },
			 panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<C-x><C-z>",
					refresh = "gr",
					open = "<C-F>"
				},
				layout = {
					position = "bottom",
					ratio = 0.4
				},
			},
		  filetypes = {
				["*"] = true, -- enable for all file types
			},
		}
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
						["<C-Tab>"] = cmp.mapping(
							function(fallback)
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
							["<S-Tab>"] = cmp.mapping(
								function()
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
		vim.keymap.set('i', '<C-Tab>', 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
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
		vim.lsp.enable('clangd')
		vim.lsp.config.clangd =
			{
			  single_file_support = true,
				capabilities = capabilities,
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				filetype = { "c", "cpp", "objc", "objcpp", "cuda" },
				init_options = {
							usePlaceholders = true,
										completeUnimported = true,
													clangdFileStatus = true,
															},
				cmd = { "clangd", "--background-index", "--query-driver=/nix/store/b9bfidnwbpi5rr6rqkkwdn76fg9dhbqc-xtensa-esp-elf-esp-idf-v5.5/bin/xtensa-esp32-elf-gcc*",
								"--clang-tidy","--compile-commands-dir=/home/justin/Code/tankrobot/build/","--completion-style=detailed",
								}
			}
		
	'';
  };
}

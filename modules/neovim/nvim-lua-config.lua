-- Restored full Neovim Lua configuration extracted from original setup.
-- NOTE: This file is referenced by modules/neovim/default.nix as extraLuaConfig.

-- ============================================================================
-- NEOVIM CONFIGURATION
-- ============================================================================

-- Set the leader key to space for custom keybindings
vim.g.mapleader = " "

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Check if there are words before the cursor (used for completion)
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Send keys to Neovim (helper function for keybindings)
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- ============================================================================
-- BASIC PLUGIN SETUP
-- ============================================================================
require("lualine").setup()
require("fidget").setup()
pcall(function() require("fidget-spinner").init() end)
require("which-key").setup()
require("ibl").setup()

-- Telescope setup
require("telescope").setup({
	defaults = {
		file_ignore_patterns = { ".git/" },
	},
	extensions = {
		ui_select = require("telescope.themes").get_dropdown({}),
	},
})
require("telescope").load_extension("ui-select")

-- Mini diff setup
pcall(function() require("mini.diff").setup() end)

-- Neotree setup
require("neo-tree").setup({
	close_if_last_window = true,
	enable_git_status = true,
	enable_diagnostics = true,
})


-- Keymaps
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neotree" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Conform.nvim setup
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		nix = { "nixfmt" },
	},
	format_on_save = true,
	notify_on_error = true,
})

vim.keymap.set("n", "<leader>rf", function()
	require("conform").format({ async = true })
end, { desc = "Format file with conform.nvim" })

-- Diagnostics config
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "vsnip" } }, { { name = "buffer" } }),
})

-- LSP setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "<leader>gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })

-- Rust LSP
vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			imports = { granularity = { group = "module" }, prefix = "self" },
			cargo = { allFeatures = true, buildScripts = { enable = true } },
			procMacro = { enable = true },
			assist = { importEnforceGranularity = true, importPrefix = "crate" },
			inlayHints = { lifetimeElisionHints = { enable = true, useParameterNames = true } },
		},
	},
})

-- Python LSP
vim.lsp.enable("pyright")
vim.lsp.config.pyright = {
	capabilities = capabilities,
	settings = {
		python = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true, useLibraryCodeForTypes = true } },
	},
}

-- C/C++ LSP
vim.lsp.enable("clangd")
vim.lsp.config.clangd = {
	single_file_support = true,
	capabilities = capabilities,
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
	cmd = {
		"clangd",
		"--background-index",
		-- Adjust the query-driver path below if it changes across rebuilds
		"--query-driver=clang-*",
		"--clang-tidy",
		"--completion-style=detailed",
	},
}

-- Nix LSP
vim.lsp.enable("nil_ls")
vim.lsp.config.nil_ls = { capabilities = capabilities }


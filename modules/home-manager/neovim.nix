{ pkgs, ... }:
let
  codecompanion-nvim-latest = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion-nvim";
    version = "2025-08-11";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "02b5a14926be3d37fbfa19de5e8336db8a5711e6"; # you can pin to a commit hash instead of branch
      sha256 = "sha256-Z9oXfBJCzg7j61wcegkutPK14cgWfuoQDRLdWq//mJs="; # replace with actual hash from nix-prefetch
    };
    buildInputs = [
      pkgs.vimPlugins.plenary-nvim
    ];
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
    pname = "conform.nvim";
    version = "v1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "stevearc";
      repo = "conform.nvim";
      tag = "v9.0.0";
      sha256 = "sha256-H9JLiRtixDKDN50SH6gkqgjlhLzHMAaOT1pc69ZFdco="; # replace with actual hash from nix-prefetch
    };
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
    ];
  };
  fidgetSpinnner = pkgs.vimUtils.buildVimPlugin {
    pname = "fidget-spinner";
    src = ./custom-neovim-plugins/fidget-spinner;
    version = "0.1.0";
  };
in
{
  home-manager.users.justin.programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-lspconfig
      nvim-cmp
      vim-vsnip
      cmp-nvim-lsp
      copilot-lua
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
      codecompanion-nvim-latest
      conformNvim
      fidgetSpinnner
    ];

    extraConfig = ''
      colorscheme tokyonight-night
      set noexpandtab
      set nu
    '';

    extraPackages = with pkgs; [
      nodejs
      nil
      gcc
      tree-sitter
      nodePackages.prettier
      black
      pyright
      nixfmt-rfc-style
      stylua
    ];
    extraLuaConfig = ''
      -- Utility functions
      vim.g.mapleader = ' '
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                 :sub(col, col)
                 :match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(key, true, true, true),
          mode,
          true
        )
      end

      -- Lualine setup
      require('lualine').setup()
      -- Fidget setup
      require('fidget').setup()
      -- Fidget spinner setup
      require('fidget-spinner').setup()
      -- Which-key setup
      require('which-key').setup()

      -- Telescope setup
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            ".git/",
          },
        },
        extensions = {
          ui_select = require("telescope.themes").get_dropdown {}
        }
      }

      -- Mini diff setup
      require('mini.diff').setup()

      -- Neotree setup
      require('neo-tree').setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
      })

      -- Code companion setup
      require('codecompanion').setup({
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["file"] = {
                callback = "strategies.chat.slash_commands.file",
                description = "Select a file using telescope",
                opts = {
                  provider = "telescope",
                  contains_code = true,
                },
              },
            },
          },
          inline = {
            adapter = "copilot"
          },
          cmd = {
            adapter = "copilot"
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4",
                },
              },
            })
          end,
        },
        display = {
          diff = {
            enabled = true,
            close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
            layout = "vertical", -- vertical|horizontal split for default provider
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            provider = "mini_diff", -- default|mini_diff
          },
          action_palette = {
            width = 95,
            height = 10,
            provider = "telescope",
          },
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
            title = "AI Slop Actions",
          }
        },
      })

      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neotree' })
      vim.keymap.set('n', '<leader>ai', ':CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat' })

      -- Telescope UI Select extension
      require('telescope').load_extension('ui-select')
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

      -- Conform.nvim setup
      require('conform').setup {
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          rust = { 'rustfmt' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          nix = { 'nixfmt' },
        },
        format_on_save = true,
        notify_on_error = true,
      }

      -- Conform keybindings
      vim.keymap.set('n', '<leader>rf', function()
        require('conform').format({ async = true })
      end, { desc = 'Format file with conform.nvim' })

      -- Copilot setup
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
          enabled = false,
        },
        filetypes = {
          ["*"] = true, -- enable for all file types
        },
      }

      vim.g.copilot_no_tab_map = true
      vim.keymap.set(
        'i',
        '<C-Tab>',
        'copilot#Accept("\\<CR>")',
        { expr = true, replace_keycodes = false }
      )

      -- Diagnostics config
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
      }

      -- nvim-cmp setup
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
        }, {
          { name = 'buffer' },
        })
      })

      -- LSP setup
      -- r = refactorings, g = goto/get information
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { desc = 'Go to references' })
      vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, { desc = 'Rename symbol' })
      vim.keymap.set('n', '<leader>gi', vim.lsp.buf.hover, { desc = 'Show hover information' })
      vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help, { desc = 'Show signature help' })

      vim.lsp.enable('rust_analyzer')
      vim.lsp.config('rust_analyzer', {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            imports = {
              granularity = {
                group = 'module',
              },
              prefix = 'self',
            },
            cargo = {
              allFeatures = true,
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
            assist = {
              importEnforceGranularity = true,
              importPrefix = 'crate',
            },
            inlayHints = {
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              },
            },
          },
        },
      })

      vim.lsp.enable('pyright')
      vim.lsp.config.pyright = {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      }

      vim.lsp.enable('clangd')
      vim.lsp.config.clangd = {
        single_file_support = true,
        capabilities = capabilities,
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        cmd = {
          "clangd",
          "--background-index",
          "--query-driver=/nix/store/b9bfidnwbpi5rr6rqkkwdn76fg9dhbqc-xtensa-esp-elf-esp-idf-v5.5/bin/xtensa-esp32-elf-gcc*",
          "--clang-tidy",
          "--compile-commands-dir=/home/justin/Code/tankrobot/build/",
          "--completion-style=detailed",
        }
      }

      vim.lsp.enable('nil_ls')
      vim.lsp.config.nil_ls = {
        capabilities = capabilities,
      }

    '';
  };
}

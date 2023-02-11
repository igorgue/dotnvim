return {
  "tpope/vim-fugitive",
  event = "BufReadPost",
  cmd = "Git",
  dependencies = {
    "tpope/vim-git",
  },
  { "github/copilot.vim", event = { "BufReadPost", "BufNewFile" } },
  {
    "mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      "tamago324/cmp-zsh",
      "uga-rosa/cmp-dictionary",
      "amarakon/nvim-cmp-fonts",
      "onsails/lspkind.nvim",
    },
    opts = function(_, _)
      local cmp = require("cmp")
      local sources = {}
      if vim.fn.has("win32") == 1 then
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        }, {
          { name = "treesitter" },
          { name = "buffer" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "fonts", options = { space_filter = "-" } },
        })
      else
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        }, {
          { name = "treesitter" },
          { name = "buffer" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "zsh" }, -- problems in windows
          { name = "fonts", options = { space_filter = "-" } },
        })
      end

      if vim.fn.has("win32") == 1 then
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
        })
      else
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "zsh" }, -- problems in windows
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
        })
      end

      local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").load()

      -- local mapping for nvim-cmp.
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))

        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- <Tab> is used by Copilot, I found the plugin doesn't work
      -- if I use <Tab> for nvim-cmp or any other plugin
      local mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.mapping.complete({})
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm(),
      }

      -- cmp plugin
      local cmp_symbols = {
        Text = " ",
        Method = " ",
        Function = "",
        Constructor = " ",
        Field = " ",
        Variable = " ",
        Class = " ",
        Interface = " ",
        Module = " ",
        Property = " ",
        Unit = "塞",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = " ",
        Event = "",
        Operator = " ",
        TypeParameter = " ",
      }

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
          { name = "dictionary" },
          { name = "spell" },
          { name = "path" },
        }),
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_document_symbol" },
          { name = "dictionary" },
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path", options = { trailing_slash = true, label_trailing_slash = true } },
          { name = "dictionary" },
          { name = "buffer" },
        }),
      })

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered({ winhighlight = winhighlight }),
          documentation = cmp.config.window.bordered({ winhighlight = winhighlight }),
          preview = cmp.config.window.bordered({ winhighlight = winhighlight }),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol",
            ellipsis_char = "…",
            menu = {
              nvim_lsp = "lsp",
              nvim_lua = "lua",
              luasnip = "snip",
              buffer = "buf",
              path = "path",
              calc = "calc",
              vsnip = "snip",
              nvim_lsp_signature_help = "sign",
              treesitter = "ts",
              spell = "spel",
              dictionary = "dict",
              zsh = "zsh",
              ["vim-dadbod-completion"] = "db",
            },
            symbol_map = cmp_symbols,
          }),
        },
        mapping = cmp.mapping.preset.insert(mapping),
        sources = sources,
      }
    end,
  },
  {
    "tpope/vim-dadbod",
    cmd = "DBUI",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      return {
        sources = {
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.pylint,
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  -- stylua: ignore
  keys = function() return {} end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "David-Kunz/markid",
      "p00f/nvim-ts-rainbow",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      "theHamsta/nvim-treesitter-pairs",
      "theHamsta/nvim-dap-virtual-text",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      require("treesitter-context").setup()
      require("nvim-dap-virtual-text").setup({})

      -- enable html parser in htmldjango file
      local import_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
      if import_parsers then
        local parsername = parsers.filetype_to_parsername
        parsername.htmldjango = "html"
      end

      local import_tag, autotag = pcall(require, "nvim-ts-autotag")
      if not import_tag then
        return
      end
      autotag.setup({
        autotag = {
          enable = true,
        },
        filetypes = {
          "html",
          "htmldjango",
        },
      })
    end,
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true,
      },
      markid = {
        enable = true,
        -- queries = {
        --     default = [[
        --         (
        --          (identifier) @markid
        --          (#not-has-parent? @markid function_definition class_definition dotted_name)
        --         )
        --     ]],
        -- },
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
      },
      refactor = {
        enable = true,
        clear_on_cursor_move = false,
        highlight_definitions = { enable = true },
      },
      pairs = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
    },
    keys = {
      { "<leader>ux", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show TS and VIM highlight groups" },
    },
  },
}

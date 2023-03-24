local utils = require("utils")

return {
  {
    "tpope/vim-fugitive",
    event = "BufReadPost",
    cmd = { "Git", "Gread", "Gwrite" },
    dependencies = {
      "tpope/vim-git",
    },
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.copilot_filetypes = {
        TelescopeResults = false,
        TelescopePrompt = false,
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "f3fora/cmp-spell",
      "tamago324/cmp-zsh",
      "uga-rosa/cmp-dictionary",
      "onsails/lspkind.nvim",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local sources = {
        {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
        },
        {
          { name = "buffer" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
        },
      }
      local mappings = {
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm(), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-j>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }

      if vim.fn.has("win32") ~= 1 then
        table.insert(sources[2], { name = "zsh" })
      end

      local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
          { name = "dictionary" },
          { name = "spell" },
          { name = "path" },
        }),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_document_symbol" },
          { name = "dictionary" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path", options = { trailing_slash = true, label_trailing_slash = true } },
          { name = "dictionary" },
          { name = "buffer" },
        }),
      })

      opts.window = {
        completion = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
        documentation = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
        preview = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
      }

      opts.sources = cmp.config.sources(sources[1], sources[2])

      opts.mapping = cmp.mapping.preset.insert(mappings)

      return opts
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")

      opts.diagnostic_config = utils.ui.diagnostic_config
      opts.border = "single"

      opts.sources = {
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.mix,
        nls.builtins.formatting.ruff,
        nls.builtins.formatting.black,
        nls.builtins.formatting.rustfmt,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.dart_format,
        nls.builtins.formatting.swiftlint,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.rustywind.with({ extra_filetypes = { "rust", "elixir" } }),
        nls.builtins.diagnostics.swiftlint,
      }

      return opts
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "David-Kunz/markid",
      "HiPhish/nvim-ts-rainbow2",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
      "theHamsta/nvim-treesitter-pairs",
      "theHamsta/nvim-dap-virtual-text",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
    },
    -- init = function()
    --   -- stylua: ignore
    --   if vim.o.diff then return end
    --
    --   vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertEnter" }, {
    --     -- files I use, I suspect I should add a bunch
    --     pattern = { "*.py", "*.ex", "*.rs", "*.dart", "*.js", "*.json" },
    --     callback = function()
    --       local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
    --
    --       if filesize < 50000 then
    --         return
    --       end
    --
    --       vim.b.autoformat = false
    --       vim.opt_local.foldmethod = "manual"
    --
    --       -- disable "some" treesitter in the current buffer
    --       vim.cmd([[
    --         TSBufDisable markid
    --         TSBufDisable indent
    --         TSBufDisable highlight
    --         TSBufDisable rainbow
    --         TSBufDisable refactor
    --         TSBufDisable pairs
    --         TSBufDisable autotag
    --         TSBufDisable matchup
    --         TSBufDisable incremental_selection
    --         TSBufDisable playground
    --         TSBufDisable query_linter
    --         TSBufDisable refactor.highlight_definitions
    --         TSBufDisable refactor.navigation
    --         TSBufDisable refactor.smart_rename
    --         TSBufDisable refactor.highlight_current_scope
    --       ]])
    --
    --       vim.notify_once(
    --         "* Treesitter degraded\n" .. "* autoformat off\n" .. "* foldmethod manual",
    --         vim.log.levels.WARN,
    --         { title = "File is too large! (" .. (filesize / 1000) .. "kb > 50kb)" }
    --       )
    --     end,
    --   })
    -- end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      require("treesitter-context").setup()
      require("nvim-dap-virtual-text").setup()

      -- enable html parser in htmldjango file
      pcall(vim.treesitter.language.register, "htmldjango", "html")

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
      disable = utils.ts_disable,
      auto_install = true,
      highlight = {
        enable = true,
        disable = utils.ts_disable,
      },
      markid = {
        enable = true,
        disable = utils.ts_disable,
      },
      indent = {
        enable = true,
        disable = utils.ts_disable,
      },
      rainbow = {
        enable = true,
        query = "rainbow-parens",
        disable = utils.ts_disable,
      },
      refactor = {
        enable = true,
        clear_on_cursor_move = true,
        highlight_definitions = { enable = true },
        disable = utils.ts_disable,
      },
      pairs = {
        enable = true,
        disable = utils.ts_disable,
      },
      autotag = {
        enable = true,
        disable = utils.ts_disable,
      },
      matchup = {
        enable = true,
        disable = utils.ts_disable,
      },
      incremental_selection = {
        enable = true,
        disable = utils.ts_disable,
      },
    },
    keys = {
      { "<leader>ux", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show Highlight Groups" },
    },
  },
}

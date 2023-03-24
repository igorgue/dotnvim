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
    "lewis6991/gitsigns.nvim",
    -- stylua: ignore
    cond = function() return not vim.o.diff end,
    opts = {
      signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
    keys = {
      { "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next Git Hunk" },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewLog",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      diff_binaries = true,
      enhanced_diff_hl = true,
      view = {
        default = {
          winbar_info = true,
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.list = false
          vim.opt_local.wrap = false

          vim.opt_local.cursorline = true
          vim.opt_local.number = true
          vim.opt.signcolumn = "no"
        end,
        view_closed = function()
          vim.opt.signcolumn = "auto"
        end,
      },
    },
    keys = {
      {
        "<leader>gd",
        function()
          local view = require("diffview.lib").get_current_view()

          if view then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle diff view",
      },
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
        },
      }
      local mappings = {
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({}),
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
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

      local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      local cmdline_mappings = {
        ["<Tab>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
        }),
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(cmdline_mappings),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(cmdline_mappings),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path", options = { trailing_slash = true, label_trailing_slash = true } },
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
    config = function(_, opts)
      opts.rainbow.strategy = require("ts-rainbow").strategy["local"]

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

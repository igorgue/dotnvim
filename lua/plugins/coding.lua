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
    opts = function(_, opts)
      local cmp = require("cmp")
      local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:Search"

      opts.window = {
        completion = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
        documentation = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
        preview = cmp.config.window.bordered({ winhighlight = winhighlight, border = "single" }),
      }
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
        nls.builtins.formatting.isort,
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
      -- "HiPhish/nvim-ts-rainbow2",
      -- "nvim-treesitter/nvim-treesitter-refactor",
      -- "nvim-treesitter/nvim-treesitter-context",
      -- "theHamsta/nvim-treesitter-pairs",
      "theHamsta/nvim-dap-virtual-text",
      -- "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
    },
    init = function()
      -- stylua: ignore
      if vim.o.diff then return end

      -- vim.api.nvim_create_autocmd("BufReadPost", {
      --   -- files I use, I suspect I should add a bunch
      --   pattern = { "*.py", "*.ex", "*.rs", "*.dart", "*.js", "*.json" },
      --   callback = function()
      --     local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
      --
      --     if filesize < 50000 then
      --       return
      --     end
      --
      --     vim.b.autoformat = false
      --     vim.opt_local.foldmethod = "manual"
      --
      --     -- disable "some" treesitter in the current buffer
      --     vim.cmd([[
      --       " TSBufDisable markid
      --       " TSBufDisable indent
      --       TSBufDisable highlight
      --       " TSBufDisable rainbow
      --       " TSBufDisable refactor
      --       TSBufDisable pairs
      --       TSBufDisable autotag
      --       TSBufDisable matchup
      --       TSBufDisable incremental_selection
      --       TSBufDisable playground
      --       TSBufDisable query_linter
      --       " TSBufDisable refactor.highlight_definitions
      --       " TSBufDisable refactor.navigation
      --       " TSBufDisable refactor.smart_rename
      --       " TSBufDisable refactor.highlight_current_scope
      --     ]])
      --
      --     vim.notify(
      --       "* Treesitter degraded\n" .. "* autoformat off\n" .. "* foldmethod manual",
      --       vim.log.levels.WARN,
      --       { title = "File is too large! (" .. (filesize / 1000) .. "kb > 50kb)" }
      --     )
      --   end,
      -- })
    end,
    config = function(_, opts)
      -- opts.rainbow["strategy"] = require("ts-rainbow.strategy.local")

      require("nvim-treesitter.configs").setup(opts)

      -- require("treesitter-context").setup()
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
      auto_install = true,
      highlight = {
        enable = false,
      },
      markid = {
        enable = true,
      },
      indent = {
        enable = false,
      },
      rainbow = {
        enable = true,
        query = "rainbow-parens",
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
      { "<leader>ux", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Show Highlight Groups" },
    },
  },
}

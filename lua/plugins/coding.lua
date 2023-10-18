local Util = require("lazyvim.util")

return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gread",
      "Gwrite",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
    dependencies = {
      "tpope/vim-git",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    -- stylua: ignore
    enabled = not vim.o.diff,
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
      { "<leader>H", "<cmd>lua require('gitsigns').prev_hunk()<cr>", desc = "Prev Git Hunk" },
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
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.copilot_no_tab_remap = false
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"] = true,
        TelescopeResults = false,
        TelescopePrompt = false,
      }
    end,
    keys = {
      {
        "<leader>cC",
        function()
          if vim.g.copilot_enabled == 0 then
            vim.cmd("Copilot enable")
          else
            vim.cmd("Copilot disable")
          end

          vim.cmd("Copilot status")
        end,
        desc = "Copilot toggle",
      },
    },
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
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
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

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      local cmd_mappings = {
        ["<Tab>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(cmd_mappings),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(cmd_mappings),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
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
      opts.experimental = {}

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    init = function()
      local conform_opts = {
        format = {
          timeout_ms = 5000,
          async = false,
          lsp_fallback = "always",
          quiet = true,
        },
      }

      -- Install the conform formatter on VeryLazy
      require("lazyvim.util").on_very_lazy(function()
        require("lazyvim.util").format.register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            require("conform").format(Util.merge(conform_opts.format, { bufnr = buf }))
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)

      -- disable formatting (and some other options) for big files
      vim.api.nvim_create_autocmd({ "BufReadPost" }, {
        callback = function()
          local ui_utils = require("utils").ui
          local buf = vim.api.nvim_get_current_buf()
          local disable = ui_utils.disable_fn(buf)

          if not disable then
            return false
          end

          vim.notify_once(
            "File too large\n* conform off\n" .. "* foldmethod manual\n" .. "* disable winbar",
            vim.log.levels.WARN
          )

          ---@diagnostic disable-next-line: inject-field
          vim.b.autoformat = false
          vim.opt_local.winbar = ""
          vim.opt_local.foldmethod = "manual"

          return true
        end,
      })
    end,
    opts = {
      formatters_by_ft = {
        html = { "rustywind" },
        elixir = { "mix" },
        python = { "black", "isort", "ruff_format", "ruff_fix" },
        zsh = { "shfmt" },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
    },
  },
}

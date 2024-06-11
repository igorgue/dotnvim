local elixir_ft = { "elixir", "eex", "heex", "surface" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, elixir_ft)
      else
        opts.ensure_installed = elixir_ft
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = elixir_ft,
    opts = {
      setup = {
        -- stylua: ignore start
        elixirls = function() return true end,
        nextls = function() return true end,
        -- stylua: ignore end
      },
    },
  },
  {
    "elixir-tools/elixir-tools.nvim",
    dependencies = {
      "elixir-editors/vim-elixir",
      "nvim-lua/plenary.nvim",
    },
    ft = elixir_ft,
    -- stylua: ignore
    enabled = not vim.o.diff,
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      local register_keys = function()
        local wk = require("which-key")
        local bufnr = vim.api.nvim_get_current_buf()

        wk.register({
          p = { "<cmd>ElixirToPipe<cr>", "To Pipe" },
          P = { "<cmd>ElixirFromPipe<cr>", "From Pipe" },
          m = { "<cmd>ElixirExpandMacro<cr>", "Expand Macro" },
          r = { "<cmd>ElixirRestart<cr>", "Restart" },
          o = { "<cmd>ElixirOutputPanel<cr>", "Output Panel" },
        }, {
          prefix = "<leader>cE",
          name = "+elixir",
          buffer = bufnr,
        })
      end

      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = { "elixir", "eex", "heex", "surface" }, callback = register_keys }
      )

      elixir.setup({
        nextls = {
          enable = true,
          init_options = {
            experimental = {
              completions = {
                enable = true,
              },
            },
            extensions = {
              credo = {
                enable = true,
              },
              elixir = {
                enable = true,
              },
            },
          },
        },
        credo = { enable = false },
        elixirls = { enable = false },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- TODO: this needs to use the one on elixirtools not mason's
      local mason = (os.getenv("HOME") or "") .. "/.local/share/nvim/mason"
      local dap = require("dap")

      dap.adapters.elixir = {
        type = "executable",
        command = mason .. "/packages/elixir-ls/debugger.sh",
      }

      dap.configurations.elixir = {
        {
          type = "elixir",
          name = "Run Elixir Program",
          task = "phx.server",
          taskArgs = { "--trace" },
          request = "launch",
          startApps = true, -- for Phoenix projects
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
      }
    end,
  },
}

local elixir_ft = { "elixir", "eelixir", "eex", "heex", "surface", "livebook" }
local elixir_ts_languages = { "elixir", "eex", "heex", "surface" }
vim.filetype.add({
  extension = {
    ["neex"] = "heex",
  },
})

local ok, icons = pcall(require, "nvim-web-devicons")
if ok then
  icons.set_icon({
    [".neex"] = { icon = "", color = "#916AB2", name = "Neex" },
  })
  icons.set_icon({
    neex = { icon = "", color = "#916AB2", name = "Neex" },
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = elixir_ts_languages,
    },
  },
  {
    "neovim/nvim-lspconfig",
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
    -- stylua: ignore
    enabled = not vim.o.diff,
    ft = elixir_ft,
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")
      local wk = require("which-key")

      wk.add({
        { "<leader>cE", group = "elixir" },
      })

      elixir.setup({
        nextls = {
          enable = true,
          spitfire = true,
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
        elixirls = {
          enable = false,
          settings = elixirls.settings({
            dialyzerEnabled = false,
            fetchDeps = false,
            enableTestLenses = false,
            suggestSpecs = false,
          }),
        },
      })
    end,
    keys = {
      {
        "<leader>cEp",
        "<cmd>ElixirToPipe<cr>",
        desc = "To Pipe",
        ft = elixir_ft,
      },
      {
        "<leader>cEP",
        "<cmd>ElixirFromPipe<cr>",
        desc = "From Pipe",
        ft = elixir_ft,
      },
      {
        "<leader>cEm",
        "<cmd>ElixirExpandMacro<cr>",
        desc = "Expand Macro",
        ft = elixir_ft,
      },
      {
        "<leader>cEr",
        "<cmd>ElixirRestart<cr>",
        desc = "Restart",
        ft = elixir_ft,
      },
      {
        "<leader>cEo",
        "<cmd>ElixirOutputPanel<cr>",
        desc = "Output Panel",
        ft = elixir_ft,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local elixir_ls = os.getenv("HOME")
        .. "/.cache/nvim/elixir-tools.nvim/installs/elixir-lsp/elixir-ls/tags_v0.22.0/1.18.1-27"
      local dap = require("dap")

      dap.adapters.elixir = {
        type = "executable",
        command = elixir_ls .. "/debug_adapter.sh",
        args = {},
      }

      dap.configurations.elixir = {
        {
          type = "elixir",
          name = "Run Elixir Program",
          request = "launch",
          task = "phx.server",
          taskArgs = { "--trace" },
          startApps = true,
          projectDir = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "SmiteshP/nvim-navic",
    optional = true,
    opts = {
      lsp = {
        preference = { "nextls" },
      },
    },
  },
}

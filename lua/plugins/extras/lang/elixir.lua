local elixir_ft = { "elixir", "eelixir", "eex", "heex", "surface", "livebook" }
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
  { import = "lazyvim.plugins.extras.lang.elixir" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        elixirls = function() return true end,
      },
    },
  },
  {
    "elixir-tools/elixir-tools.nvim",
    ft = elixir_ft,
    dependencies = {
      "elixir-editors/vim-elixir",
      "nvim-lua/plenary.nvim",
    },
    -- stylua: ignore
    enabled = not vim.o.diff,
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
        credo = { enable = true },
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
      local dap = require("dap")
      local adapter = LazyVim.get_pkg_path("elixir-ls", "debug_adapter.sh")

      dap.adapters.elixir = {
        type = "executable",
        command = adapter,
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
  -- do not overwrite the dap adapter setup
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        elixir = function() end,
      },
    },
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

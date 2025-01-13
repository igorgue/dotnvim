local elixir_ft = { "elixir", "eex", "heex", "surface" }

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
  -- {
  --   "SmiteshP/nvim-navic",
  --   optional = true,
  --   opts = {
  --     lsp = {
  --       preference = { "nextls" },
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    ft = elixir_ft,
    opts = {
      ensure_installed = elixir_ft,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
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

        wk.add({
          { "<leader>cE", group = "elixir" },
          { "<leader>cEp", "<cmd>ElixirToPipe<cr>", desc = "To Pipe" },
          { "<leader>cEP", "<cmd>ElixirFromPipe<cr>", desc = "From Pipe" },
          { "<leader>cEm", "<cmd>ElixirExpandMacro<cr>", desc = "Expand Macro" },
          { "<leader>cEr", "<cmd>ElixirRestart<cr>", desc = "Restart" },
          { "<leader>cEo", "<cmd>ElixirOutputPanel<cr>", desc = "Output Panel" },
        }, { buffer = bufnr })
      end

      vim.api.nvim_create_autocmd(
        "FileType",
        { pattern = { "elixir", "eex", "heex", "surface" }, callback = register_keys }
      )

      elixir.setup({
        nextls = {
          enable = false,
          spitfire = true,
          init_options = {
            experimental = {
              completions = {
                enable = false,
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
          enable = true,
          tag = "v0.26.2",
          settings = elixirls.settings({
            dialyzerEnabled = true,
            fetchDeps = false,
          }),
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local elixir_ls = os.getenv("HOME")
        .. "/.cache/nvim/elixir-tools.nvim/installs/elixir-lsp/elixir-ls/v0.26.2/1.18.1-27"
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
}

vim.env.NEXTLS_SPITFIRE_ENABLED = 1

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
  {
    "SmiteshP/nvim-navic",
    optional = true,
    opts = {
      lsp = {
        preference = { "nextls" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, elixir_ft)
      else
        opts.ensure_installed = elixir_ft
      end

      opts.highlight = {
        enable = true,
      }

      opts.indent = {
        enable = true,
      }
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
        credo = { enable = true },
        elixirls = { enable = true, tag = "v0.26.2" },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- FIXME: I think this is broken... Is not debugging right now,
      -- lets use `pry` instead...
      -- TODO: this needs to use the one on elixir-tools not mason's
      -- elixir-tools does not download this `debug_adaper.sh` script
      -- but mason does, so we use the one on mason.
      local mason = (os.getenv("HOME") or "") .. "/.local/share/nvim/mason"
      local dap = require("dap")

      dap.adapters.elixir = {
        type = "executable",
        command = mason .. "/packages/elixir-ls/debug_adapter.sh",
      }

      dap.configurations.elixir = {
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
      }
    end,
  },
}

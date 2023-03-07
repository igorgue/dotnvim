return {
  {
    "mhanberg/elixir.nvim",
    dependencies = {
      "elixir-editors/vim-elixir",
    },
    ft = { "elixir", "eex", "heex", "surface" },
    config = function()
      local elixir = require("elixir")
      -- local mason = (os.getenv("HOME") or "") .. "/.local/share/nvim/mason"

      elixir.setup({
        -- specify a repository and branch
        repo = "elixir-lsp/elixir-ls",
        -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
        -- cmd = mason .. "/packages/elixir-ls/language_server.sh",

        -- default settings, use the `settings` function to override settings
        settings = require("elixir").settings({
          dialyzerEnabled = false,
          -- dialyzerFormat = "dialyxir_long",
          -- dialyzerWarnOpts = []
          enableTestLenses = false,
          -- envVariables =
          fetchDeps = false,
          -- languageServerOverridePath =
          mixEnv = "dev",
          -- mixTarget = "host",
          -- projectDir = "",
          signatureAfterComplete = false,
          suggestSpecs = false,
          log_level = vim.lsp.protocol.MessageType.Log,
          message_level = vim.lsp.protocol.MessageType.Log,
          trace = {
            server = "off",
          },
        }),
        on_attach = function(_, _)
          require("lazyvim.util").on_attach(function(_, bufnr)
            local wk = require("which-key")
            local elixir_opts = { noremap = true, silent = true, buffer = bufnr }
            local nvim_del_keymap = vim.api.nvim_del_keymap

            pcall(nvim_del_keymap, "n", "<leader>cp")
            pcall(nvim_del_keymap, "n", "<leader>cP")
            pcall(nvim_del_keymap, "n", "<leader>cm")
            pcall(nvim_del_keymap, "n", "<leader>cR")
            pcall(nvim_del_keymap, "n", "<leader>cO")

            wk.register({
              c = {
                p = { "<cmd>ElixirToPipe<cr>", "Elixir to pipe", opts = elixir_opts },
                P = { "<cmd>ElixirFromPipe<cr>", "Elixir from pipe", opts = elixir_opts },
                m = { "<cmd>ElixirExpandMacro<cr>", "Elixir expand macro", opts = elixir_opts },
                R = { "<cmd>ElixirRestart<cr>", "Elixir restart", opts = elixir_opts },
                O = { "<cmd>ElixirOutputPanel<cr>", "Elixir LSP output panel", opts = elixir_opts },
              },
            }, {
              prefix = "<leader>",
            })
          end)
        end,
      })
    end,
  },
}

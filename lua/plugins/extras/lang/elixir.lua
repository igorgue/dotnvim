return {
  {
    "neovim/nvim-lspconfig",
    ft = { "elixir", "eex", "heex", "surface" },
    opts = {
      setup = {
        -- stylua: ignore
        elixirls = function() return true end,
      },
    },
  },
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
        -- repo = "elixir-lsp/elixir-ls",
        -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
        -- cmd = mason .. "/packages/elixir-ls/language_server.sh",
        cmd = "elixir-ls",

        -- default settings, use the `settings` function to override settings
        settings = elixir.settings({
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
        on_attach = function()
          local register_keys = function()
            local wk = require("which-key")

            wk.register({
              p = { "<cmd>ElixirToPipe<cr>", "Elixir to pipe" },
              P = { "<cmd>ElixirFromPipe<cr>", "Elixir from pipe" },
              M = { "<cmd>ElixirExpandMacro<cr>", "Elixir expand macro" },
              R = { "<cmd>ElixirRestart<cr>", "Elixir restart" },
              O = { "<cmd>ElixirOutputPanel<cr>", "Elixir LSP output panel" },
            }, {
              prefix = "<leader>c",
              buffer = vim.api.nvim_get_current_buf(),
            })
          end

          register_keys()
          vim.api.nvim_create_autocmd("FileType", { pattern = "elixir", callback = register_keys })
        end,
      })
    end,
  },
}

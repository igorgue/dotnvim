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
    -- stylua: ignore
    cond = function() return not vim.o.diff end,
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

      vim.api.nvim_create_autocmd("FileType", { pattern = "elixir", callback = register_keys })

      elixir.setup({
        -- specify a repository and branch
        -- repo = "elixir-lsp/elixir-ls",
        -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
        -- cmd = mason .. "/packages/elixir-ls/language_server.sh",
        cmd = "elixir-ls",

        elixirls = {
          settings = {
            elixirls.settings({
              dialyzerEnabled = true,
              dialyzerFormat = "dialyxir_long",
              -- dialyzerWarnOpts = []
              enableTestLenses = true,
              -- envVariables =
              fetchDeps = false,
              -- languageServerOverridePath =
              mixEnv = "dev",
              -- mixTarget = "host",
              -- projectDir = "",
              signatureAfterComplete = true,
              suggestSpecs = true,
              log_level = vim.lsp.protocol.MessageType.Log,
              message_level = vim.lsp.protocol.MessageType.Log,
              trace = {
                server = "on",
              },
            }),
          },
        },
      })
    end,
  },
}

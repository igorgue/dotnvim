-- vim.lsp.enable("kotlin_lsp")

return {
  { import = "lazyvim.plugins.extras.lang.kotlin" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     setup = {
  --       kotlin_language_server = function()
  --         return true
  --       end,
  --     },
  --   },
  -- },
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       kotlin = { "ktfmt" },
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     linters_by_ft = { kotlin = {} },
  --   },
  -- },
}

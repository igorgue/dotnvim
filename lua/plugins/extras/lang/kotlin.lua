vim.lsp.enable("kotlin_lsp", false)

return {
  { import = "lazyvim.plugins.extras.lang.kotlin" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     setup = {
  --       kotlin_lsp = function()
  --         return true
  --       end,
  --     },
  --     servers = {
  --       kotlin_lsp = false,
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

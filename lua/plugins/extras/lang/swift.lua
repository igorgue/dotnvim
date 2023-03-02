return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "objective-c", "objective-cpp" },
    cond = function()
      return vim.fn.executable("sourcekit-lsp") == 1 and vim.fn.has("mac") == 1
    end,
    opts = {
      servers = {
        sourcekit = {},
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "objective-c", "objective-cpp" },
    opts = {
      servers = {
        sourcekit = {},
      },
    },
  },
}

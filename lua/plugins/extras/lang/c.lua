return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities = {
            offsetEncoding = { "utf-16" },
          }
        end,
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    opts = {
      setup = {
        clangd = function(_, clangd_opts)
          clangd_opts.capabilities = {
            offsetEncoding = { "utf-16" },
          }
        end,
      },
    },
  },
}

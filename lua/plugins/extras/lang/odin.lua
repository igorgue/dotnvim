return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Tetralux/odin.vim",
    },
    ft = { "odin" },
    opts = {
      servers = {
        ols = {},
      },
    },
  },
}

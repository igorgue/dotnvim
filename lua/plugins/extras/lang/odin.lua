return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Tetralux/odin.vim",
    },
    ft = "odin",
    opts = {
      servers = {
        ols = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "odin" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        odin = { "odinfmt" },
      },
    },
  },
}

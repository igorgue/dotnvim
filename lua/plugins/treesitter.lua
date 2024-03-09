return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        disable = true,
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}

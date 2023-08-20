return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
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

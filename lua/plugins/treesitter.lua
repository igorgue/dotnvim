return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- FIXME: These two plugins, are slow, I cannot deal with them anymore
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

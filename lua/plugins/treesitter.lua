return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    cmd = { "TSEnable", "TSBufEnable" },
    -- stylua: ignore
    event = function() return {} end,
    opts = {
      highlight = { enable = true },
      indent = { enable = false },
      -- I use "michaeljsmith/vim-indent-object" instead
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      endwise = { enable = true },
    },
  },
}

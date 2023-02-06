return {
  {
    "michaeljsmith/vim-indent-object",
    lazy = true,
    keys = {
      { "vai", nil, desc = "An indent level and line above" },
      { "vii", nil, desc = "Inner indent level (no line above)" },
      { "vaI", nil, desc = "An indent level and lines above/below" },
      { "viI", nil, desc = "Inner indent level (no lines above/below)" },
      { "dai", nil, desc = "An indent level and line above" },
      { "dii", nil, desc = "Inner indent level (no line above)" },
      { "daI", nil, desc = "An indent level and lines above/below" },
      { "diI", nil, desc = "Inner indent level (no lines above/below)" },
      { "cai", nil, desc = "An indent level and line above" },
      { "cii", nil, desc = "Inner indent level (no line above)" },
      { "caI", nil, desc = "An indent level and lines above/below" },
      { "ciI", nil, desc = "Inner indent level (no lines above/below)" },
    },
  },
  { "arp242/xdg_open.vim", lazy = true },
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
  },
}

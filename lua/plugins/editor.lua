return {
  {
    "michaeljsmith/vim-indent-object",
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
  "arp242/xdg_open.vim",
  {
    "lewis6991/gitsigns.nvim",
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
    keys = function()
      return {
        { "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next git hunk" },
      }
    end,
  },
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "echasnovski/mini.ai",
    enabled = false,
  },
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
}

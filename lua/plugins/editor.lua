return {
  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
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
  {
    "arp242/xdg_open.vim",
    event = { "BufReadPost", "BufNewFile" },
  },
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
    keys = {
      { "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", desc = "Next git hunk" },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add surrounding", mode = "x" },
    },
  },
  {
    "windwp/nvim-spectre",
    opts = {
      highlight = {
        ui = "String",
        search = "IncSearch",
        replace = "DiffChange",
        border = "FloatBorder",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "none",
        margin = { 0, 0, 0, 0 },
        padding = { 0, 0, 0, 0 },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
}

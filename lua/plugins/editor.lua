return {
  {
    "echasnovski/mini.ai",
    optional = true,
    keys = {
      { "<c-space>", "<cmd>normal vii0<cr>", desc = "Inner Indent Level (No Line Above)" },
      { "<c-space>", "<cmd>normal ii0<cr>", desc = "Inner Indent Level (No Line Above)", mode = "x" },
    },
  },
  {
    "michaeljsmith/vim-indent-object",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "vai", nil, desc = "An Indent Level and Line Above" },
      { "vii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "vaI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "viI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "dai", nil, desc = "An Indent Level and Line Above" },
      { "dii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "daI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "diI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "cai", nil, desc = "An Indent Level and Line Above" },
      { "cii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "caI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "ciI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "<c-space>", "<cmd>normal viI<cr>", desc = "Inner Indent Level" },
      { "<c-space>", "<cmd>normal iI<cr>", desc = "Inner Indent Level", mode = "x" },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add Surrounding", mode = "x" },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
      { "<leader>mm", "<cmd>Telescope marks<cr>", desc = "Search marks" },
      { "<leader>md", "<cmd>delmarks!<cr>", desc = "Delete marks" },
    },
  },
  {
    "andymass/vim-matchup",
    event = "LazyFile",
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
}

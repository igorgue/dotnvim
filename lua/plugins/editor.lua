return {
  {
    "michaeljsmith/vim-indent-object",
    keys = {
      { "vai", nil, desc = "An Indent Level and Line Above" },
      { "vii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "vaI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "viI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "<c-space>", "<cmd>normal vii<cr>", desc = "Inner Indent Level (No Line Above)" },
      { "<c-space>", "<cmd>normal ii<cr>", desc = "Inner Indent Level (No Line Above)", mode = "x" },
      { "dai", nil, desc = "An Indent Level and Line Above" },
      { "dii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "daI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "diI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
      { "cai", nil, desc = "An Indent Level and Line Above" },
      { "cii", nil, desc = "Inner Indent Level (No Line Above)" },
      { "caI", nil, desc = "An Indent Level and Lines Above/Below" },
      { "ciI", nil, desc = "Inner Indent Level (No Lines Above/Below)" },
    },
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add Surrounding", mode = "x" },
    },
  },
}

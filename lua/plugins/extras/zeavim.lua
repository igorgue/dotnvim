return {
  {
    "KabbAmine/zeavim.vim",
    cmd = { "Zeavim", "ZeavimV" },
    keys = {
      { "<leader>z", "<Plug>Zeavim", "Launch Zeal" },
      { "<leader>Z", "<Plug>ZVKeyDocset", "Zeal Docset" },
      { "<leader>z", "<Plug>ZVVisSelection", "Search Zeal", mode = "v" },
      { "gz", "<Plug>ZVOperator", "Zeal Operator" },
    },
  },
}

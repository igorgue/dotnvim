return {
  {
    "ptdewey/yankbank-nvim",
    dependencies = "kkharji/sqlite.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      persist_type = "sqlite",
      num_behavior = "jump",
      max_entries = 100,
    },
    keys = {
      { "<leader>p", "<cmd>YankBank<CR>", desc = "Open YankBank" },
    },
  },
}

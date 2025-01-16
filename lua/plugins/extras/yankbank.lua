return {
  {
    "ptdewey/yankbank-nvim",
    dependencies = "kkharji/sqlite.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("yankbank").setup({
        persist_type = "sqlite",
        num_behavior = "jump",
      })
    end,
    keys = {
      { "<leader>P", "<cmd>YankBank<CR>", desc = "Open YankBank" },
    },
  },
}

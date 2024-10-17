return {
  {
    "ptdewey/yankbank-nvim",
    dependencies = "kkharji/sqlite.lua",
    config = function()
      require("yankbank").setup({
        persist_type = "sqlite",
        num_behavior = "jump",
      })
    end,
    keys = {
      { "<leader>p", "<cmd>YankBank<CR>", desc = "Open YankBank" },
    },
  },
}
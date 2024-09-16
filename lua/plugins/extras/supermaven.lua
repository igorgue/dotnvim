return {
  {
    "L3MON4D3/LuaSnip",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "nvim-cmp",
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      keymaps = {
        accept_suggestion = "<tab>",
        clear_suggestion = "<c-]>",
        accept_word = "<c-s-j>",
      },
    },
    keys = {
      {
        "<leader>am",
        function()
          require("supermaven").toggle()
        end,
        desc = "Supermaven toggle",
      },
    },
  },
}

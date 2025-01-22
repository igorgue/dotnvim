return {
  desc = "Rainbow delimiters for treesitter",
  "HiPhish/rainbow-delimiters.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  lazy = false,
  init = function()
    -- This module contains a number of default definitions
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        ["*"] = rainbow_delimiters.strategy["global"],
      },
      query = {
        [""] = "rainbow-delimiters",
        ["*"] = "rainbow-delimiters",
        jinja = "rainbow-blocks",
        lua = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
}

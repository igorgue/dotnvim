return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "danger",
    },
  },
  { "igorgue/danger", event = "VeryLazy" },
  -- { dir = "~/Code/danger", event = "VeryLazy" },
  {
    "folke/tokyonight.nvim",
    config = function()
      local colors = require("tokyonight.colors")

      -- create a new palette based on the default colors
      colors.danger = vim.deepcopy(colors.default)

      colors.danger.none = "NONE"

      colors.danger.bg = "#161925"
      colors.danger.bg_dark = "#394160"
      colors.danger.bg_highlight = "#262B40"
      colors.danger.terminal_black = "#161925"

      colors.danger.dark3 = "#454555"
      colors.danger.dark5 = "#394160"

      colors.danger.comment = "#6c6c6c"

      colors.danger.fg = "#dadada"
      colors.danger.fg_dark = "#626262"
      colors.danger.fg_gutter = "#161925"

      colors.danger.magenta2 = "#ffd7ff"
      colors.danger.magenta = "#8787d7"

      colors.danger.orange = "#ff8787"
      colors.danger.purple = "#875fff"

      colors.danger.red1 = "#ff5f00"
      colors.danger.red = "#ff3525"

      colors.danger.teal = "#00af87"
      colors.danger.yellow = "#ffd75f"

      colors.danger.green1 = "#afd7af"
      colors.danger.green2 = "#00524b"
      colors.danger.green = "#cbe6ff"

      colors.danger.cyan = "#cbe6ff"

      colors.danger.blue0 = "#8787d7"
      colors.danger.blue1 = "#c4c9f3"
      colors.danger.blue2 = "#eac9e4"
      colors.danger.blue5 = "#b1a7cd"
      colors.danger.blue6 = "#cbb9ad"
      colors.danger.blue7 = "#c7a0c3"
      colors.danger.blue = "#875fff"

      colors.danger.git = {
        add = "#00af87",
        change = "#ff5f00",
        delete = "#ff3525",
      }

      colors.danger.gitSigns = {
        add = "#00af87",
        change = "#ff5f00",
        delete = "#ff3525",
      }

      -- load your style
      require("tokyonight").load({ style = "danger" })
    end,
  },
}

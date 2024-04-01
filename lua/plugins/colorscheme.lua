-- complete a few colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "zaibatsu", "caret", "candy", "ir_black", "ir_blue", "ir_dark" },
  callback = function()
    vim.cmd("hi SignColumn guibg=NONE")
    vim.cmd("hi! link WinBar Normal")
    vim.cmd("hi! link WinBarNC Normal")
    vim.cmd("hi! link VertSplit Type")
    vim.cmd("hi! link WinSeparator Type")
    vim.cmd("hi! link MatchParen CursorLine")

    vim.cmd("hi! link CmpItemAbbr Identifier")
    vim.cmd("hi! link CmpItemAbbrDeprecated Identifier")
    vim.cmd("hi! link CmpItemAbbrMatch String")
    vim.cmd("hi! link CmpItemAbbrMatchFuzzy String")
    vim.cmd("hi! link CmpItemKind Type")
    vim.cmd("hi! link CmpItemMenu Function")

    vim.cmd("hi! link DashboardHeader Identifier")
    vim.cmd("hi! link DashboardCenter String")
    vim.cmd("hi! link DashboardShortcut Type")
    vim.cmd("hi! link DashboardFooter LineNr")
    vim.cmd("hi! link DashboardKey String")
    vim.cmd("hi! link DashboardDesc Type")
    vim.cmd("hi! link DashboardIcon Identifier")

    if vim.g.colors_name == "zaibatsu" then
      vim.cmd("hi! link WhichKeyFloat Normal")
      vim.cmd("hi! link LazyNormal Normal")
    else
      vim.cmd("hi! link WhichKeyFloat Visual")
    end

    if vim.fn.executable("kitty") and vim.env.KITTY_WINDOW_ID then
      if vim.g.colors_name == "ir_black" then
        vim.fn.system("kitty @ set-colors -a background=black")
      end
    end
  end,
  once = true,
})

return {
  {
    -- includes catppuccin and tokyonight already
    "LazyVim/LazyVim",
    opts = {
      colorscheme = vim.env.NVIM_COLORSCHEME or "danger_dark",
    },
  },
  {
    "igorgue/danger",
    -- dir = "~/Code/danger",
    opts = {
      style = "dark",
      alacritty = true,
      kitty = true,
    },
    keys = {
      {
        "<leader>uD",
        function()
          if vim.g.colors_name == "danger_dark" then
            vim.cmd("colorscheme danger_light")
          else
            vim.cmd("colorscheme danger_dark")
          end
        end,
        desc = "Toggle Danger Dark Mode",
      },
    },
  },
  "projekt0n/caret.nvim",
  { "rose-pine/neovim", name = "rose-pine" },

  -- oldschool colorschemes
  "igorgue/candy.vim",
  "twerth/ir_black", -- oldschool colorscheme
}

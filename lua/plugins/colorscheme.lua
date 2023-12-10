-- zaibatsu, a built-in colorscheme
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.g.colors_name == "zaibatsu" then
      vim.cmd("hi SignColumn guibg=NONE")
      vim.cmd("hi! link WinBar Normal")
      vim.cmd("hi! link WinBarNC Normal")
      vim.cmd("hi! link VertSplit Type")
      vim.cmd("hi! link WinSeparator Type")
      vim.cmd("hi! link CmpItemAbbr Identifier")
      vim.cmd("hi! link CmpItemAbbrMatch Type")
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
        "<leader>D",
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
  {
    "projekt0n/caret.nvim",
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "caret" then
            vim.cmd("hi SignColumn guibg=NONE")
            vim.cmd("hi! link WinBar Normal")
            vim.cmd("hi! link WinBarNC Normal")
            vim.cmd("hi! link VertSplit Identifier")
            vim.cmd("hi! link WinSeparator Identifier")
          end
        end,
        once = true,
      })
    end,
  },
  {
    "igorgue/candy.vim", -- oldschool colorscheme
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "candy" then
            vim.cmd("hi SignColumn guibg=NONE")
            vim.cmd("hi! link WinBar Normal")
            vim.cmd("hi! link WinBarNC Normal")
            vim.cmd("hi! link VertSplit Identifier")
            vim.cmd("hi! link WinSeparator Identifier")
          end
        end,
        once = true,
      })
    end,
  },
  {
    "twerth/ir_black", -- oldschool colorscheme
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          if vim.g.colors_name == "ir_black" or vim.g.colors_name == "ir_blue" or vim.g.colors_name == "ir_dark" then
            vim.cmd("hi SignColumn guibg=NONE")
            vim.cmd("hi! link WinBar Normal")
            vim.cmd("hi! link WinBarNC Normal")
            vim.cmd("hi! link VertSplit Identifier")
            vim.cmd("hi! link WinSeparator Identifier")
          end
        end,
        once = true,
      })
    end,
  },
}

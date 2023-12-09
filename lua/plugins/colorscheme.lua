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
  "projekt0n/caret.nvim",
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
          if vim.g.colors_name == "ir_black" then
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

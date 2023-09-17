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
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = "candy",
        callback = function()
          vim.cmd("hi link Normal SignColumn")
          vim.cmd("hi link Normal LineNr")
          vim.cmd("hi link Normal StatusLine")
          vim.cmd("hi link Normal StatusLineNC")
          vim.cmd("hi link Normal FoldColumn")
          vim.cmd("hi SignColumn guibg=NONE")
        end,
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          vim.cmd("hi SignColumn guibg=NONE")
        end,
      })
    end,
  },
  {
    "twerth/ir_black", -- oldschool colorscheme
    init = function()
      vim.api.nvim_create_autocmd("Colorscheme", {
        pattern = "ir_black",
        callback = function()
          vim.cmd("hi link Normal SignColumn")
          vim.cmd("hi link Normal LineNr")
          vim.cmd("hi link Normal StatusLine")
          vim.cmd("hi link Normal StatusLineNC")
          vim.cmd("hi link Normal FoldColumn")
          vim.cmd("hi SignColumn guibg=NONE")
        end,
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
          vim.cmd("hi SignColumn guibg=NONE")
        end,
      })
    end,
  },
}

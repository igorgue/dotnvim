return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "danger",
    },
  },
  {
    "igorgue/danger",
    -- { dir = "~/Code/danger" },
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
        "Toggle Danger light / dark",
      },
    },
  },
}

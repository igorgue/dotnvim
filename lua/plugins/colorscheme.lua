return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = os.getenv("NVIM_COLORSCHEME") or "danger",
    },
  },
  {
    "igorgue/danger",
    -- dir = "~/Code/danger",
    opts = {
      style = "dark",
      alacritty = true,
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
        desc = "Toggle Danger dark mode",
      },
    },
  },
}

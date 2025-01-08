
return {
  "rakotomandimby/deepseek-complete",
  desc = "Deepseek coding assistance integration",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- FIXME: this doesn't work.
    vim.g.rktmb_deepseek_complete_opts = {
      suggest_keymap = "<C-l>",
      accept_line_keymap = "<CR>",
      accept_all_keymap = "<S-CR>",
    }
  end,
}

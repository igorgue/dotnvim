-- Kitty configuration:
--
-- # action_alias
--
-- # kitty-scrollback.nvim Kitten alias
-- action_alias kitty_scrollback_nvim kitten $HOME/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
--
-- # Browse scrollback buffer in nvim
-- map kitty_mod+h kitty_scrollback_nvim --config default
--
-- # Browse output of the last shell command in nvim
-- map kitty_mod+g kitty_scrollback_nvim --config cmd_output
--
-- # Show clicked command output in nvim
-- mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config visited_cmd_output

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("KittyScrollbackNvimFileType", { clear = true }),
  pattern = { "kitty-scrollback" },
  callback = function()
    vim.opt.laststatus = 0
    vim.opt.clipboard = "unnamedplus"
    -- vim.opt.cursorline = true

    return true
  end,
})

return {
  "mikesmithgh/kitty-scrollback.nvim",
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  event = { "User KittyScrollbackLaunch" },
  config = function(_, opts)
    local default = opts
    local cmd_output = vim.tbl_deep_extend("force", default, { kitty_get_text = { extent = "last_cmd_output" } })
    local visited_cmd_output = vim.tbl_deep_extend("force", default, { kitty_get_text = { extent = "last_visited_cmd_output" } })

    require("kitty-scrollback").setup({
      default = default,
      cmd_output = cmd_output,
      visited_cmd_output = visited_cmd_output,
    })
  end,
  opts = {
    status_window = {
      enabled = false
      -- autoclose = true
    },
    paste_window = {
      yank_register_enabled = false,
    },
  },
}

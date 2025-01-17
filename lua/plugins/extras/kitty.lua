if lazyvim_docs then
  -- Usage:
  --
  -- `kitty_mod` is `ctrl+shift` by default, mappings:
  --
  -- - `kitty_mod+h` to open, use `yy` to copy to the system's clipboard.
  -- - `kitty_mod+g` to scroll on last output.
  -- - `kitty_mod+rmb` to scroll on last command and output.
  --
  -- To quit you press `ctrl+c` or `q`, or how you'd exit LazyVim normally `:q` or `<leader>qq` or `ZZ`.
  --
  -- You must setup the following to make Kitty use Neovim as scrollback.
  --
  -- ```
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
  -- ```
end

-- kitty bg support, maybe in the future it could store the kitty bg at start
if vim.env.KITTY_WINDOW_ID and vim.env.KITTY_SCROLLBACK_NVIM ~= "true" then
  vim.g.kitty_bg = vim.fn.system("kitty @ get-colors | grep ^background | awk '{print $2}'")

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()

      local new_bg_color = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")

      vim.fn.system("kitty @ set-colors -a background=" .. new_bg_color)
    end,
  })

  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      vim.fn.system("kitty @ set-colors -a background=" .. vim.g.kitty_bg)
    end,
  })
end

return {
  "mikesmithgh/kitty-scrollback.nvim",
  desc = "Kitty background support, use neovim as scrollback",
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  event = { "User KittyScrollbackLaunch" },
  config = function(_, opts)
    local default = opts
    local cmd_output = vim.tbl_deep_extend("force", default, { kitty_get_text = { extent = "last_cmd_output" } })
    local visited_cmd_output =
      vim.tbl_deep_extend("force", default, { kitty_get_text = { extent = "last_visited_cmd_output" } })

    -- set default scrollback options
    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = vim.api.nvim_create_augroup("KittyScrollbackNvimFileType", { clear = true }),
      pattern = { "kitty-scrollback" },
      callback = opts.on_open,
    })

    require("kitty-scrollback").setup({
      default = default,
      cmd_output = cmd_output,
      visited_cmd_output = visited_cmd_output,
    })
  end,
  opts = {
    status_window = {
      enabled = false,
      autoclose = true,
    },
    paste_window = {
      yank_register_enabled = false,
    },
    on_open = function()
      vim.opt.laststatus = 0
      vim.opt.clipboard = "unnamedplus"
      vim.opt.cursorline = true
      vim.opt.number = false
      vim.opt.relativenumber = false
      vim.opt.syntax = "off"

      return true
    end,
  },
}

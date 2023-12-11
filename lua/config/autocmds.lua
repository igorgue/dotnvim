-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local util = require("lazyvim.util")

-- 2023-10-12T09:56:27 LazyVim  WARN `require("lazyvim.util").float_term` is deprecated. Please use `require("lazyvim.util").terminal.open` instead
-- commands
vim.api.nvim_create_user_command("Btop", function()
  util.terminal.open("btop")
end, {})

vim.api.nvim_create_user_command("Nap", function()
  util.terminal.open("nap")
end, {})

vim.api.nvim_create_user_command("Ranger", function()
  util.terminal.open({ "ranger" }, { cwd = util.root.get() })
end, {})

vim.api.nvim_create_user_command("Lazygit", function()
  util.terminal.open({ "lazygit" }, { cwd = util.root.get() })
end, {})

vim.api.nvim_create_user_command("Cloc", function()
  vim.schedule(function()
    local out = vim.fn.system("cloc --quiet --vcs=git --exclude-ext=json,toml,ini,txt")

    vim.notify(out, vim.log.levels.INFO, { title = "Lines of code in project" })
  end)
end, {})

vim.api.nvim_create_user_command("Screenshot", function()
  vim.notify("In 3...2...1", vim.log.levels.INFO, { title = "Screenshot" })

  vim.defer_fn(function()
    require("notify").dismiss({ pending = true, silent = true })
    vim.cmd("silent !gnome-screenshot -w &")
  end, 3000)
end, {})

-- autocmds
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- disable formatting (and some other options) for big files
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    local ui_utils = require("utils").ui
    local buf = vim.api.nvim_get_current_buf()
    local disable = ui_utils.disable_fn(buf)

    if not disable then
      return false
    end

    vim.notify_once(
      "File too large\n* conform off\n" .. "* foldmethod manual\n" .. "* disable winbar",
      vim.log.levels.WARN
    )

    ---@diagnostic disable-next-line: inject-field
    vim.b.autoformat = false
    vim.opt_local.winbar = ""
    vim.opt_local.foldmethod = "manual"

    return true
  end,
})

-- TODO: this was a fix for actually vim-illuminate,
-- but it broke many things, including opening new files
-- would do it with messed up syntax
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     vim.cmd("Lazy reload lualine.nvim")
--     vim.defer_fn(function()
--       require("notify").dismiss({ pending = true, silent = true })
--     end, 50)
--   end,
-- })

-- plugins.extras.* includes more autocmds, specific for certain files

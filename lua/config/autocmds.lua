-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local util = require("lazyvim.util")

-- commands
vim.api.nvim_create_user_command("Btop", function()
  util.float_term("btop")
end, {})

vim.api.nvim_create_user_command("Nap", function()
  util.float_term("nap")
end, {})

vim.api.nvim_create_user_command("Ranger", function()
  util.float_term({ "ranger" }, { cwd = util.get_root() })
end, {})

vim.api.nvim_create_user_command("Lazygit", function()
  util.float_term({ "lazygit" }, { cwd = util.get_root() })
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

-- plugins.extras.* includes more autocmds, specific for certain files

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api = vim.api
local util = require("lazyvim.util")

-- commands
api.nvim_create_user_command("Btop", function()
  util.float_term("btop")
end, {})

api.nvim_create_user_command("Nap", function()
  util.float_term("nap")
end, {})

api.nvim_create_user_command("Ranger", function()
  util.float_term({ "ranger" }, { cwd = util.get_root() })
end, {})

api.nvim_create_user_command("Lazygit", function()
  util.float_term({ "lazygit" }, { cwd = util.get_root() })
end, {})

api.nvim_create_user_command("Cloc", function()
  vim.schedule(function()
    local out = vim.fn.system("cloc --quiet --vcs=git --exclude-ext=json,toml,ini,txt")

    vim.notify(out, vim.log.levels.INFO, { title = "Lines of code in project" })
  end)
end, {})

api.nvim_create_user_command("Screenshot", function()
  vim.notify("In 3...2...1", vim.log.levels.INFO, { title = "Screenshot" })

  vim.defer_fn(function()
    require("notify").dismiss({})
    vim.cmd("silent !gnome-screenshot -w &")
  end, 3000)
end, {})

-- autocmds
api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- plugins.extras.* includes more autocmds, specific for certain files

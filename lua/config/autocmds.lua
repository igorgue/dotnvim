-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api = vim.api
local util = require("lazyvim.util")

-- commands
api.nvim_create_user_command("Nap", function()
  util.float_term("nap")
end, {})

api.nvim_create_user_command("Ranger", function()
  util.float_term("ranger")
end, {})

api.nvim_create_user_command("Btop", function()
  util.float_term("btop")
end, {})

api.nvim_create_user_command("Cloc", function()
  vim.schedule(function()
    local out = vim.fn.system("cloc --quiet --exclude-list=.gitignore .")

    require("notify").notify(out, vim.log.levels.INFO, { title = "Lines of code in project" })
  end)
end, {})

-- autocmds
api.nvim_create_user_command("Screenshot", function()
  local notify = require("notify")

  notify.notify("In 3...2...1", vim.log.levels.INFO, { title = "Screenshot" })

  vim.defer_fn(function()
    notify.dismiss({})
    vim.cmd("silent !gnome-screenshot -w &")
  end, 3000)
end, {})

api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("ColorizerReload", { clear = true }),
  callback = function()
    vim.cmd("ColorizerAttachToBuffer")
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "BufEnter", "CursorHold", "InsertLeave" }, {
  buffer = 0,
  callback = function()
    if next(vim.lsp.codelens.get(0)) ~= nil then
      vim.lsp.codelens.refresh()
    end
  end,
})

vim.api.nvim_create_autocmd("Colorscheme", {
  callback = function()
    local config = require("lualine").get_config()

    config.options.theme = require("utils").ui.lualine_theme()

    require("lualine").setup(config)
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local home = os.getenv("HOME") or ""

vim.api.nvim_create_user_command("Nap", function()
  vim.cmd([[
        terminal ]] .. home .. [[/go/bin/nap
        normal! a
    ]])
end, {})

vim.api.nvim_create_user_command("Ranger", function()
  vim.cmd([[
        terminal ranger
        normal! a
    ]])
end, {})

vim.api.nvim_create_user_command("Screenshot", function()
  vim.cmd([[
        !gnome-screenshot -w -d 5 &
    ]])
end, {})

vim.cmd([[
    autocmd BufEnter,CursorHold,InsertLeave <buffer> lua if next(vim.lsp.codelens.get()) ~= nil then vim.lsp.codelens.refresh() end
]])

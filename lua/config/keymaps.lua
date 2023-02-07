-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
local default_opts = { noremap = true, silent = true }
local keymap = vim.keymap

api.nvim_del_keymap("v", "<")
api.nvim_del_keymap("v", ">")

pcall(function()
  api.nvim_del_keymap("n", "<leader>g]")
end)
pcall(function()
  api.nvim_del_keymap("n", "<leader>g[")
end)

keymap.set("n", "<leader>h", "<cmd>lua require('gitsigns').next_hunk()<cr>", default_opts)
keymap.set("n", "<leader>g]", "<cmd>lua require('gitsigns').next_hunk()<cr>", default_opts)
keymap.set("n", "<leader>g[", "<cmd>lua require('gitsigns').prev_hunk()<cr>", default_opts)
keymap.set("n", "<leader>x", "<Cmd>TSHighlightCapturesUnderCursor<CR>", default_opts)

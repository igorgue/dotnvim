-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
-- local default_opts = { noremap = true, silent = true }
-- local keymap = vim.keymap
local nvim_del_keymap = api.nvim_del_keymap

pcall(nvim_del_keymap, "n", "<")
pcall(nvim_del_keymap, "n", ">")
pcall(nvim_del_keymap, "v", "<")
pcall(nvim_del_keymap, "v", ">")
pcall(nvim_del_keymap, "x", "<")
pcall(nvim_del_keymap, "x", ">")
pcall(nvim_del_keymap, "n", "<leader>l")

-- refresh key...
-- keymap.set("n", "<leader>r", function()
--   require("notify").dismiss({})
--   vim.cmd("nohlsearch")
--   vim.cmd("cd ~")
--   vim.cmd("cd -")
-- end, default_opts)

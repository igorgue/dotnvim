-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
-- local default_opts = { noremap = true, silent = true }
-- local keymap = vim.keymap
local nvim_del_keymap = api.nvim_del_keymap
local wk = require("which-key")

pcall(nvim_del_keymap, "n", "<")
pcall(nvim_del_keymap, "n", ">")
pcall(nvim_del_keymap, "v", "<")
pcall(nvim_del_keymap, "v", ">")
pcall(nvim_del_keymap, "n", "<leader>l")

-- extra which key stuff
wk.register({
  d = { name = "+debug" },
  z = { name = "+fold" },
})

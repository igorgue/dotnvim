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

-- prefixes with some names
wk.register({
  d = { name = "+debug" },
  z = { name = "+fold" },
})

wk.register({
  f = {
    R = { "<cmd>Ranger<cr>", "Ranger file explorer" },
    N = { "<cmd>Nap<cr>", "Nap notes" },
  },
  u = {
    S = { "<cmd>Screenshot<cr>", "Screenshot" },
  },
}, {
  prefix = "<leader>",
})

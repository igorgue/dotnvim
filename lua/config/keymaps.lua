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

wk.register({
  ["<leader>d"] = { name = "+debug" },
  z = { name = "+fold" },
})

wk.register({
  f = {
    R = { "<cmd>Ranger<cr>", "Ranger file explorer" },
  },
  u = {
    S = { "<cmd>Screenshot<cr>", "Take a screenshot" },
    t = { "<cmd>Btop<cr>", "Btop process manager" },
    D = { "<cmd>DBUI<cr>", "Database manager" },
    N = { "<cmd>Nap<cr>", "Nap notes" },
  },
  c = {
    ["#"] = { "<cmd>Cloc<cr>", "Count lines" },
  },
}, {
  prefix = "<leader>",
})

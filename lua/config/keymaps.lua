-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
local nvim_del_keymap = api.nvim_del_keymap
local wk = require("which-key")

pcall(nvim_del_keymap, "n", "<")
pcall(nvim_del_keymap, "n", ">")
pcall(nvim_del_keymap, "v", "<")
pcall(nvim_del_keymap, "v", ">")

wk.register({
  ["<leader><cr>"] = { name = "+applications" },
  ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
  z = { name = "+fold", mode = { "n", "v" } },
})

wk.register({
  b = { "<cmd>Btop<cr>", "Btop Process Manager" },
  n = { "<cmd>Nap<cr>", "Nap Code Snippets" },
  s = { "<cmd>Screenshot<cr>", "Gnome Screenshot" },
  r = { "<cmd>Ranger<cr>", "Ranger File Manager" },
  c = { "<cmd>Cloc<cr>", "Cloc Count Lines" },
  g = { "<cmd>Lazygit<cr>", "Lazygit" },
}, {
  prefix = "<leader><cr>",
})

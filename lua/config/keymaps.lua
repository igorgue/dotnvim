-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
local nvim_del_keymap = api.nvim_del_keymap
local wk = require("which-key")

-- Normal behaviour
pcall(nvim_del_keymap, "n", "<")
pcall(nvim_del_keymap, "n", ">")
pcall(nvim_del_keymap, "v", "<")
pcall(nvim_del_keymap, "v", ">")

-- Remove <leader>l default since it doesn't
-- get replaced in minimal mode
if vim.env.NVIM_MINIMAL ~= nil then
  pcall(nvim_del_keymap, "n", "<leader>l")
end

wk.register({
  ["<leader><cr>"] = { name = "+applications" },
  ["<leader>d"] = { name = "+debug", mode = { "n", "v" } },
  ["<leader>da"] = { name = "+adapter", mode = { "n", "v" } },
  z = { name = "+fold", mode = { "n", "v" } },
})

wk.register({
  K = { vim.lsp.buf.hover, "Hover" },
  ["<esc>"] = { require("utils").ui.refresh_ui, "Refresh UI" },
  ["<leader>L"] = { "<cmd>Lazy<cr>", "Lazy" },
  ["<leader>t"] = { ":lua require('lazyvim.util').float_term()<cr>", "Terminal (cwd)" },
  ["<leader>T"] = {
    function()
      vim.cmd("enew | terminal")
      vim.cmd("normal a")
    end,
    "Terminal (cwd, current buffer)",
  },
  ["<leader><tab>j"] = { "<cmd>tabprevious<cr>", "Previous Tab" },
  ["<leader><tab>k"] = { "<cmd>tabnext<cr>", "Next Tab" },
  ["<leader><tab>h"] = { "<cmd>tabfirst<cr>", "First Tab" },
  ["<leader><tab>l"] = { "<cmd>tablast<cr>", "Last Tab" },
  ["<leader><tab>n"] = { "<cmd>tabnew<cr>", "New Tab" },
  ["<leader><tab>1"] = { "<cmd>tabfirst<cr>", "First Tab" },
  ["<leader><tab>2"] = { "<cmd>tabnext 2<cr>", "Second Tab" },
  ["<leader><tab>3"] = { "<cmd>tabnext 3<cr>", "Third Tab" },
  ["<leader><tab>4"] = { "<cmd>tabnext 4<cr>", "Fourth Tab" },
  ["<leader><tab>5"] = { "<cmd>tabnext 5<cr>", "Fifth Tab" },
  ["<leader><tab>6"] = { "<cmd>tabnext 6<cr>", "Sixth Tab" },
  ["<leader><tab>7"] = { "<cmd>tabnext 7<cr>", "Seventh Tab" },
  ["<leader><tab>8"] = { "<cmd>tabnext 8<cr>", "Eighth Tab" },
  ["<leader><tab>9"] = { "<cmd>tabnext 9<cr>", "Ninth Tab" },
  ["<leader><tab>0"] = { "<cmd>tablast<cr>", "Last Tab" },
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

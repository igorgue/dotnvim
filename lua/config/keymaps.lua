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

wk.register({
  ["<leader><cr>"] = { name = "+applications" },
  z = { name = "+fold", mode = { "n", "v" } },
})

wk.register({
  K = { vim.lsp.buf.hover, "Hover" },
  ["<esc>"] = { require("utils").ui.refresh_ui, "Refresh UI" },
  ["<A-/>"] = { "<cmd>WhichKey<cr>", "Help", mode = { "n", "i" } },
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
  l = { "<cmd>Lazy<cr>", "Lazy" },
}, {
  prefix = "<leader><cr>",
})

-- NVIM_WASD
if vim.env.NVIM_WASD then
  -- unmap 'wasd' in normal mode (set to <nop> was okay)
  vim.api.nvim_set_keymap("n", "w", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "a", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "s", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "d", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "W", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "A", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "S", "<nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "D", "<nop>", { noremap = true, silent = true })

  wk.register({
    ["w"] = { "<up>", "Up" },
    ["a"] = { "<left>", "Left" },
    ["s"] = { "<down>", "Down" },
    ["d"] = { "<right>", "Right" },
    ["W"] = { "{", "Previous Paragraph" },
    ["A"] = { "<S-Left>", "Previous Word" },
    ["S"] = { "}", "Next Paragraph" },
    ["D"] = { "<S-Right>", "Next Word" },
  })
end

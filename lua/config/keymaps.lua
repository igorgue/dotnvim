-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

-- Remove some default keymaps
pcall(vim.api.nvim_del_keymap, "n", "<")
pcall(vim.api.nvim_del_keymap, "n", ">")
pcall(vim.api.nvim_del_keymap, "v", "<")
pcall(vim.api.nvim_del_keymap, "v", ">")
pcall(vim.api.nvim_del_keymap, "n", "<leader>gg")

wk.register({
  b = { "<cmd>Btop<cr>", "Btop Process Manager" },
  n = { "<cmd>Nap<cr>", "Nap Code Snippets" },
  r = { "<cmd>Ranger<cr>", "Ranger File Manager" },
  c = { "<cmd>Cloc<cr>", "Cloc Count Lines" },
  g = { "<cmd>Lazygit<cr>", "Lazygit" },
  l = { "<cmd>Lazy<cr>", "Lazy" },
}, {
  prefix = "<leader><cr>",
})

wk.register({
  ["<leader>"] = { name = "+leader" },
  ["<SNR>"] = { name = "+SNR" },
  ["<leader><cr>"] = { name = "+applications" },
  ["<leader>cs"] = { name = "+sourcegraph" },
  ["<leader>m"] = { name = "+molten" },
  ["<leader>a"] = { name = "+ai" },
  ["!"] = { name = "+filter", mode = { "n", "v" } },
  ["<"] = { name = "+indent/left", mode = { "n", "v" } },
  [">"] = { name = "+indent/right", mode = { "n", "v" } },
  z = { name = "+fold", mode = { "n", "v" } },
  c = { name = "+change", mode = { "n", "v" } },
  d = { name = "+delete", mode = { "n", "v" } },
  v = { name = "+visual", mode = { "n", "v" } },
  y = { name = "+yank", mode = { "n", "v" } },
})

-- Tab keymaps
wk.register({
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

local function force_format()
  if vim.bo.filetype == "mojo" then
    vim.cmd("noa silent! !mojo format --quiet " .. vim.fn.expand("%:p"))
    return
  end

  vim.cmd("LazyFormat")
end

local function toggle_line_numbers()
  vim.opt.cursorline = not vim.opt.cursorline:get()
  vim.opt.number = not vim.opt.number:get()
end

local function toggle_inlay_hints()
  if vim.opt_local.ft:get() == "c" then
    require("clangd_extensions.inlay_hints").toggle_inlay_hints()
  else
    if vim.lsp.inlay_hint == nil then
      return
    end

    local value = not vim.lsp.inlay_hint.is_enabled(0)

    vim.lsp.inlay_hint.enable(value)

    print(value and "Inlay hints enabled" or "Inlay hints disabled")
  end
end

wk.register({
  K = { vim.lsp.buf.hover, "Hover" },
  ["<esc>"] = { require("utils").ui.refresh_ui, "Refresh UI" },
  ["<A-/>"] = { "<cmd>WhichKey<cr>", "Help", mode = { "n", "i" } },
  ["<A-e>"] = { "<cmd>Telescope emoji<cr>", "Emoji Select", mode = { "n", "i" } },
  ["<A-f>"] = { force_format, "Force Format Document", mode = { "n", "v", "i" } },
  ["<A-g>"] = { "<cmd>Telescope glyph<cr>", "Glyph Select", mode = { "n", "i" } },
  ["<C-S-T>"] = { require("utils").ui.open_terminal_tab, "Open Terminal", mode = { "n", "v", "i" } },
  ["<C-f>"] = { require("utils").ui.toggle_focus_mode, "Focus Mode", mode = { "n", "v", "i" } },
  ["<C-g>"] = { require("utils").file_info, "File Info", mode = "n" },
  ["<leader>gg"] = { "<cmd>Lazygit<cr>", "Lazygit" },
  ["<leader>ul"] = { toggle_line_numbers, "Toggle Line Numbers / Cursorline" },
  ["<leader>F"] = { force_format, "Force Format Document", mode = { "n", "v" } },
  ["<leader>="] = { force_format, "Force Format Document", mode = { "n", "v" } },
  ["<leader>uh"] = { toggle_inlay_hints, "Toggle Inlay Hints", mode = "n" },
  ["<leader>o"] = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)", mode = "n" },
  ["<leader>uW"] = { require("utils").ui.toggle_winbar, "Toggle Winbar", mode = "n" },
})

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
pcall(vim.api.nvim_del_keymap, "n", "j")
pcall(vim.api.nvim_del_keymap, "n", "k")

wk.add({
  { "<leader><cr>b", "<cmd>Btop<cr>", desc = "Btop Process Manager" },
  { "<leader><cr>d", "<cmd>DBUIToggle<cr>", desc = "Dadbod Database Manager" },
  { "<leader><cr>n", "<cmd>Nap<cr>", desc = "Nap Code Snippets" },
  { "<leader><cr>y", "<cmd>Yazi<cr>", desc = "Yazi File Manager" },
  { "<leader><cr>c", "<cmd>Cloc<cr>", desc = "Cloc Count Lines" },
  { "<leader><cr>g", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  { "<leader><cr>l", "<cmd>Lazy<cr>", desc = "Lazy" },
  { "<leader><cr>C", "<cmd>ChessTui<cr>", desc = "Chess TUI" },
})

wk.add({
  { "<leader>", group = "leader" },
  { "<SNR>", group = "SNR" },
  { "<leader><cr>", group = "applications" },
  { "<leader>cs", group = "sourcegraph" },
  { "<leader>m", group = "molten" },
  { "<leader>a", group = "ai", mode = { "n", "v", "i" } },
  { "!", group = "filter", mode = { "n", "v" } },
  { "<", group = "indent/left", mode = { "n", "v" } },
  { ">", group = "indent/right", mode = { "n", "v" } },
  { "c", group = "change", mode = { "n", "v" } },
  { "d", group = "delete", mode = { "n", "v" } },
  { "v", group = "visual", mode = { "n", "v" } },
  { "y", group = "yank", mode = { "n", "v" } },
})

-- Tab keymaps
wk.add({
  { "<leader><tab>j", "<cmd>tabprevious<cr>", desc = "Previous Tab" },
  { "<leader><tab>k", "<cmd>tabnext<cr>", desc = "Next Tab" },
  { "<leader><tab>h", "<cmd>tabfirst<cr>", desc = "First Tab" },
  { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last Tab" },
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New Tab" },
  { "<leader><tab>1", "<cmd>tabfirst<cr>", desc = "First Tab" },
  { "<leader><tab>2", "<cmd>tabnext 2<cr>", desc = "Second Tab" },
  { "<leader><tab>3", "<cmd>tabnext 3<cr>", desc = "Third Tab" },
  { "<leader><tab>4", "<cmd>tabnext 4<cr>", desc = "Fourth Tab" },
  { "<leader><tab>5", "<cmd>tabnext 5<cr>", desc = "Fifth Tab" },
  { "<leader><tab>6", "<cmd>tabnext 6<cr>", desc = "Sixth Tab" },
  { "<leader><tab>7", "<cmd>tabnext 7<cr>", desc = "Seventh Tab" },
  { "<leader><tab>8", "<cmd>tabnext 8<cr>", desc = "Eighth Tab" },
  { "<leader><tab>9", "<cmd>tabnext 9<cr>", desc = "Ninth Tab" },
  { "<leader><tab>0", "<cmd>tablast<cr>", desc = "Last Tab" },
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

    local value = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })

    vim.lsp.inlay_hint.enable(value)

    vim.notify(value and "Inlay hints enabled" or "Inlay hints disabled")
  end
end

wk.add({
  { "<esc>", require("utils").ui.refresh_ui, desc = "Refresh UI" },
  { "<A-/>", "<cmd>WhichKey<cr>", desc = "Help", mode = { "n", "i" } },
  { "<A-e>", "<cmd>Telescope emoji<cr>", desc = "Emoji Select", mode = { "n", "i" } },
  { "<A-f>", force_format, desc = "Force Format Document", mode = { "n", "v", "i" } },
  { "<A-g>", "<cmd>Telescope glyph<cr>", desc = "Glyph Select", mode = { "n", "i" } },
  { "<C-f>", require("utils").ui.toggle_focus_mode, desc = "Focus Mode", mode = { "n", "v", "i" } },
  { "<C-S-T>", require("utils").ui.open_terminal_tab, desc = "Open Terminal", mode = { "n", "v", "i" } },
  { "<C-g>", require("utils").file_info, desc = "File Info", mode = "n" },
  { "<leader>X", "<cmd>LazyExtras<cr>", desc = "Lazy Extras" },
  { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  { "<leader>F", force_format, desc = "Force Format Document", mode = { "n", "v" } },
  { "<leader>=", force_format, desc = "Force Format Document", mode = { "n", "v" } },
  { "<leader>o", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", mode = "n" },
  { "<leader>uh", toggle_inlay_hints, desc = "Toggle Inlay Hints", mode = "n" },
  { "<leader>ul", toggle_line_numbers, desc = "Toggle Line Numbers / Cursorline" },
  { "<leader>uW", require("utils").ui.toggle_winbar, desc = "Toggle Winbar", mode = "n" },
  { "<leader>uR", require("utils").ui.toggle_lsp_references, desc = "Toggle LspReferences", mode = "n" },
  { "<c-y>", [["+y]], desc = "Copy to clipboard", mode = "x", icon = "" },
  { "<c-p>", [["+p]], desc = "Paste from clipboard", mode = { "x", "n" }, icon = "" },
})

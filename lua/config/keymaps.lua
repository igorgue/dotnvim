-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local wk = require("which-key")

-- Normal behaviour
pcall(vim.api.nvim_del_keymap, "n", "<")
pcall(vim.api.nvim_del_keymap, "n", ">")
pcall(vim.api.nvim_del_keymap, "v", "<")
pcall(vim.api.nvim_del_keymap, "v", ">")

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

wk.register({
  K = { vim.lsp.buf.hover, "Hover" },
  ["<esc>"] = { require("utils").ui.refresh_ui, "Refresh UI" },
  ["<A-/>"] = { "<cmd>WhichKey<cr>", "Help", mode = { "n", "i" } },
  ["<A-e>"] = { "<cmd>Telescope emoji<cr>", "Emoji Select", mode = { "n", "i" } },
  ["<A-g>"] = { "<cmd>Telescope glyph<cr>", "Glyph Select", mode = { "n", "i" } },
})

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

-- toggle diagnostics and copilot in focus mode with ctrl+f
wk.register({
  ["<C-f>"] = { require("utils").toggle_focus_mode, "Focus Mode", mode = { "n", "v", "i" } },
})

-- open terminal with ctrl+shift+t (when not in kitty terminal, since it grabs that keymap)
wk.register({
  ["<C-S-T>"] = { require("utils").open_terminal_tab, "Open Terminal", mode = { "n", "v", "i" } },
})

vim.api.nvim_del_keymap("n", "<leader>gg")

wk.register({
  gg = { "<cmd>Lazygit<cr>", "Lazygit" },
}, {
  prefix = "<leader>",
})

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
  l = {
    function()
      Util.toggle("cursorline")
      Util.toggle.number()
      vim.opt.relativenumber = false
    end,
    "Toggle Line Numbers / Cursorline",
  },
}, {
  prefix = "<leader>u",
})

local function force_format()
  if vim.bo.filetype == "mojo" then
    vim.cmd("noa silent! !mojo format --quiet " .. vim.fn.expand("%:p"))
    return
  end

  vim.cmd("LazyFormat")
end

-- my formatter function, simpler, always format,
-- with "leader =" also "leader F"
wk.register({
  ["="] = { force_format, "Force Format Document", mode = { "n", "v" } },
  F = { force_format, "Force Format Document", mode = { "n", "v" } },
}, {
  prefix = "<leader>",
})

-- also <A-f> because why not
wk.register({
  ["<A-f>"] = { force_format, "Force Format Document", mode = { "n", "v", "i" } },
})

wk.register({
  ["<leader>uh"] = {
    function()
      if vim.opt_local.ft:get() == "c" then
        require("clangd_extensions.inlay_hints").toggle_inlay_hints()
      else
        if vim.lsp.inlay_hint == nil then
          return
        end

        local value = not vim.lsp.inlay_hint.is_enabled(0)

        vim.lsp.inlay_hint.enable(0, value)

        print(value and "Inlay hints enabled" or "Inlay hints disabled")
      end
    end,
    "Toggle Inlay Hints",
    mode = "n",
  },
})

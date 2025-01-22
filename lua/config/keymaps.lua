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
pcall(vim.api.nvim_del_keymap, "n", "<leader>ul")
pcall(vim.api.nvim_del_keymap, "n", "<leader>uh")

-- group names
wk.add({
  { "<leader>", group = "leader" },
  { "<SNR>", group = "snr" },
  { "<leader>A", group = "applications" },
  { "<leader>cg", group = "github" },
  { "m", group = "marks" },
  { "<leader>m", group = "marks" },
  { "<leader>a", group = "ai", mode = { "n", "v", "i" } },
  { "!", group = "filter", mode = { "n", "v" } },
  { "<", group = "indent/left", mode = { "n", "v" } },
  { ">", group = "indent/right", mode = { "n", "v" } },
  { "c", group = "change", mode = { "n", "v" } },
  { "d", group = "delete", mode = { "n", "v" } },
  { "v", group = "visual", mode = { "n", "v" } },
  { "y", group = "yank", mode = { "n", "v" } },
})

-- '.' +more groups
wk.add({
  { "<leader>u.", group = "more", mode = { "n", "v", "s" } },
  { "<leader>f.", group = "more", mode = { "n", "v", "s" } },
})

-- applications
wk.add({
  { "<leader>Ab", "<cmd>Btop<cr>", desc = "Btop Process Manager" },
  { "<leader>Ad", "<cmd>DBUIToggle<cr>", desc = "Dadbod Database Manager" },
  { "<leader>An", "<cmd>Nap<cr>", desc = "Nap Code Snippets" },
  { "<leader>Ay", "<cmd>Yazi<cr>", desc = "Yazi File Manager" },
  { "<leader>Ac", "<cmd>Cloc<cr>", desc = "Cloc Count Lines" },
  { "<leader>Ag", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  { "<leader>Al", "<cmd>Lazy<cr>", desc = "Lazy" },
  { "<leader>AC", "<cmd>ChessTui<cr>", desc = "Chess TUI" },
})

-- tab keymaps
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
  { "dm", "<cmd>Delmarks<cr>", desc = "Delete current line marks" },
  { "<esc>", require("utils").ui.refresh_ui, desc = "Refresh UI" },
  { "<A-/>", "<cmd>WhichKey<cr>", desc = "Help", mode = { "n", "i" } },
  {
    "<A-f>",
    force_format,
    desc = "Force Format Document",
    mode = { "n", "v", "i" },
  },
  {
    "<A-s>",
    "<cmd>Telescope symbols<cr>",
    desc = "Symbols Select",
    mode = { "n", "i" },
  },
  {
    "<A-e>",
    "<cmd>Telescope emoji<cr>",
    desc = "Emoji Select",
    mode = { "n", "i" },
  },
  {
    "<A-g>",
    "<cmd>Telescope glyph<cr>",
    desc = "Glyph Select",
    mode = { "n", "i" },
  },
  { "<A-s-o>", "{", desc = "{", mode = { "n", "i" } },
  { "<A-s-p>", "}", desc = "}", mode = { "n", "i" } },
  {
    "<C-S-T>",
    require("utils").ui.open_terminal_tab,
    desc = "Open Terminal",
    mode = { "n", "v", "i" },
  },
  { "<C-g>", require("utils").file_info, desc = "File Info", mode = "n" },
  {
    "<leader>F",
    require("utils").ui.toggle_focus_mode,
    desc = "Focus Mode",
    mode = "n",
  },
  { "<leader>X", "<cmd>LazyExtras<cr>", desc = "Lazy Extras" },
  { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  {
    "<leader>=",
    force_format,
    desc = "Force Format Document",
    mode = { "n", "v" },
  },
  {
    "<leader>o",
    "<cmd>Trouble symbols toggle focus=false<cr>",
    desc = "Symbols (Trouble)",
    mode = "n",
  },
  { "<leader>uh", toggle_inlay_hints, desc = "Toggle Inlay Hints", mode = "n" },
  {
    "<leader>uW",
    require("utils").ui.toggle_winbar,
    desc = "Toggle Winbar",
    mode = "n",
  },
  {
    "<leader>uR",
    require("utils").ui.toggle_lsp_references,
    desc = "Toggle LspReferences",
    mode = "n",
  },
  {
    "<leader>N",
    Snacks.notifier.hide,
    desc = "Clear Notifications",
    mode = "n",
  },
  {
    "<leader>y",
    '^v$"+y',
    desc = "Copy to clipboard",
    mode = "n",
    icon = { icon = "", color = "grey" },
  },
  {
    "<leader>y",
    '"+y',
    desc = "Copy to clipboard",
    mode = "v",
    icon = { icon = "", color = "grey" },
  },
  {
    "<leader>p",
    '"+p',
    desc = "Paste from clipboard",
    mode = { "v", "n" },
    icon = { icon = "", color = "grey" },
  },
})

-- Snacks' toggles
Snacks.toggle({
  name = "Line Numbers",
  get = function()
    return vim.opt.number:get()
  end,
  set = function(state)
    vim.opt.number = state
    vim.opt.cursorline = state
    -- Snacks.toggle.indent():toggle(state)
  end,
}):map("<leader>ul")

Snacks.toggle({
  name = "Status Line",
  get = function()
    return vim.api.nvim_get_option_value("laststatus", {}) ~= 0
  end,
  set = function(state)
    vim.opt.laststatus = state and 3 or 0
  end,
}):map("<leader>u.l")

Snacks.toggle({
  name = "Diffview",
  get = function()
    return require("diffview.lib").get_current_view() ~= nil
  end,
  set = function(state)
    vim.cmd("Diffview" .. (state and "Open" or "Close"))
  end,
}):map("<leader>gD")

-- some special cases:
pcall(vim.api.nvim_del_keymap, "v", "<C-k>")
pcall(vim.api.nvim_del_keymap, "i", "<C-k>")

if LazyVim.has("luasnip") then
  wk.add({
    {
      "<C-k>",
      function()
        local luasnip = require("luasnip")

        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          vim.cmd("wincmd k")
        end
      end,
      desc = "Jump back with luasnip or move window up",
      mode = { "v", "s" },
    },
    {
      "<C-k>",
      function()
        local luasnip = require("luasnip")

        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          if vim.fn.mode() == "i" then
            vim.api.nvim_input("<C-s-k>")
          else
            vim.cmd("wincmd k")
          end
        end
      end,
      desc = "Jump back with luasnip or move window up",
      mode = { "i", "s" },
    },
  })
else
  wk.add({
    {
      "<C-k>",
      function()
        if vim.snippet.active({ direction = -1 }) then
          vim.snippet.jump(-1)
        else
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          else
            if vim.fn.mode() == "i" then
              vim.api.nvim_input("<C-s-k>")
            else
              vim.cmd("wincmd k")
            end
          end
        end
      end,
      desc = "Jump back with snippet or move window up",
      mode = { "i", "s" },
    },
  })
end

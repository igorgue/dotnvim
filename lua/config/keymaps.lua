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
pcall(vim.api.nvim_del_keymap, "n", "<leader>gd")
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
  { "<leader>gd", group = "diff" }, -- git/diff
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
  { "<esc>", require("utils").ui.refresh_ui, desc = "Refresh UI" },
  { "<M-/>", "<cmd>WhichKey<cr>", desc = "Help", mode = { "n", "i" } },
  {
    "<leader>F",
    force_format,
    desc = "Force Format Document",
  },
  {
    "<M-s>",
    function()
      if vim.g.lazyvim_picker == "telescope" then
        vim.cmd("Telescope symbols")
      else
        Snacks.picker.icons()
      end
    end,
    desc = "Symbols Select",
    mode = { "n", "i" },
  },
  { "<M-s-o>", "{", desc = "{", mode = { "n", "i" } },
  { "<M-s-p>", "}", desc = "}", mode = { "n", "i" } },
  {
    "<C-S-T>",
    require("utils").ui.open_terminal_tab,
    desc = "Open Terminal",
    mode = { "n", "v", "i" },
  },
  { "<C-g>", require("utils").file_info, desc = "File Info", mode = "n" },
  { "<leader>X", "<cmd>LazyExtras<cr>", desc = "Lazy Extras" },
  { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  {
    "<leader>gdh",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Git Diff (hunks)",
  },
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
}):map("<leader>gdd")

Snacks.toggle({
  name = "Focus Mode",
  get = function()
    return vim.g.focus_mode
  end,
  set = function(state)
    require("utils").ui.toggle_focus_mode(state)
  end,
})
  :map("<M-f>", { mode = { "v", "i", "n" } })
  :map("<leader>u.f")

Snacks.toggle({
  name = "LSP References",
  get = function()
    return vim.api.nvim_get_hl(0, { name = "LspReferenceRead" }).link ~= nil
  end,
  set = function(state)
    require("utils").ui.toggle_lsp_references(state)
  end,
}):map("<leader>uR")

Snacks.toggle({
  name = "Winbar",
  get = function()
    return vim.opt.winbar:get() ~= ""
  end,
  set = function(state)
    require("utils").ui.toggle_winbar(state)
  end,
}):map("<leader>uW")

Snacks.toggle({
  name = "Blink",
  get = function()
    return not vim.g.cmp_disabled
  end,
  set = function(state)
    vim.g.cmp_disabled = not state
  end,
})
  :map("<M-b>", { mode = { "v", "i", "n" } })
  :map("<leader>cb")

Snacks.toggle({
  name = "Github Copilot",
  get = function()
    if LazyVim.has("copilot.vim") then
      return vim.api.nvim_call_function("g:copilot#Enabled", {}) ~= 0
    else
      if LazyVim.has("copilot.lua") then
        return not require("copilot.client").is_disabled()
      end
    end
  end,
  set = function(state)
    vim.cmd("Copilot " .. (state and "enable" or "disable"))
  end,
}):map("<leader>aC")

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

-- Marks support with m0..9
-- which put crazy bad marks on my buffers
pcall(vim.api.nvim_del_keymap, "n", "m0")
pcall(vim.api.nvim_del_keymap, "n", "m1")
pcall(vim.api.nvim_del_keymap, "n", "m2")
pcall(vim.api.nvim_del_keymap, "n", "m3")
pcall(vim.api.nvim_del_keymap, "n", "m4")
pcall(vim.api.nvim_del_keymap, "n", "m5")
pcall(vim.api.nvim_del_keymap, "n", "m6")
pcall(vim.api.nvim_del_keymap, "n", "m7")
pcall(vim.api.nvim_del_keymap, "n", "m8")
pcall(vim.api.nvim_del_keymap, "n", "m9")

local function toggle_mark(mark)
  local current_pos = vim.fn.getpos("'" .. mark)
  local cursor_pos = vim.fn.getpos(".")
  if current_pos[1] == 0 then
    vim.cmd("mark " .. mark)
  elseif current_pos[2] == cursor_pos[2] then
    vim.cmd("delmarks " .. mark)
  else
    vim.fn.setpos("'" .. mark, cursor_pos)
  end
end

-- stylua: ignore
wk.add({
  { "m1", function() toggle_mark("A") end, desc = "Toggle mark A" },
  { "m2", function() toggle_mark("B") end, desc = "Toggle mark B" },
  { "m3", function() toggle_mark("C") end, desc = "Toggle mark C" },
  { "m4", function() toggle_mark("D") end, desc = "Toggle mark D" },
  { "m5", function() toggle_mark("E") end, desc = "Toggle mark E" },
  { "m6", function() toggle_mark("F") end, desc = "Toggle mark F" },
  { "m7", function() toggle_mark("G") end, desc = "Toggle mark G" },
  { "m8", function() toggle_mark("H") end, desc = "Toggle mark H" },
  { "m9", function() toggle_mark("I") end, desc = "Toggle mark I" },
  { "m0", function() toggle_mark("J") end, desc = "Toggle mark J" },
})

wk.add({
  { "`1", "`A", desc = "Go to mark A" },
  { "`2", "`B", desc = "Go to mark B" },
  { "`3", "`C", desc = "Go to mark C" },
  { "`4", "`D", desc = "Go to mark D" },
  { "`5", "`E", desc = "Go to mark E" },
  { "`6", "`F", desc = "Go to mark F" },
  { "`7", "`G", desc = "Go to mark G" },
  { "`8", "`H", desc = "Go to mark H" },
  { "`9", "`I", desc = "Go to mark I" },
  { "`0", "`J", desc = "Go to mark J" },
})

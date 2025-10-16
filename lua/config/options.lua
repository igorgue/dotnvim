-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local utils = require("utils")

vim.opt.signcolumn = "auto"
vim.opt.statuscolumn = ""
vim.opt.laststatus = 0
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.list = false
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = ""
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.pumblend = 0
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.scrolloff = 3
vim.opt.foldmethod = "manual"
vim.opt.diffopt = {
  algorithm = "histogram",
  linematch = 60,
  "internal",
  "indent-heuristic",
  "filler",
  "closeoff",
  "iwhite",
  "vertical",
}
vim.opt.listchars = {
  tab = "──",
  lead = "·",
  trail = "·",
  nbsp = "␣",
  eol = "↵",
  precedes = "«",
  extends = "»",
}
vim.opt.fillchars = {
  -- "vert:▏",
  vert = "│",
  diff = "╱",
  foldclose = "",
  foldopen = "",
  fold = " ",
  msgsep = "─",
  eob = " ",
}
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.isfname:append(":")
vim.opt.smoothscroll = false

vim.opt.clipboard = ""

if vim.o.diff ~= false then
  vim.opt.list = false
  vim.opt.wrap = false

  vim.opt.signcolumn = "no"
  vim.opt.cursorline = true
  vim.opt.number = true
end

-- sets the tabline to not show x, a very simple tabline
local function nox_tab_label(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local name = vim.fn.fnamemodify(vim.fn.bufname(buflist[winnr]), ":t")
  if name == "" then
    return "[No Name]"
  end
  return name
end

function _G.NoXTabLine()
  local s = ""
  local total = vim.fn.tabpagenr("$")
  local current = vim.fn.tabpagenr()
  for i = 1, total do
    s = s .. (i == current and "%#TabLineSel#" or "%#TabLine#") .. "%" .. i .. "T " .. nox_tab_label(i) .. " "
  end
  s = s .. "%#TabLineFill#%T"
  if total > 1 then
    s = s .. "%=%#TabLine#%999X"
  end
  return s
end

vim.o.tabline = "%!v:lua.NoXTabLine()"

vim.diagnostic.config(utils.ui.diagnostic_config)

if vim.version().minor >= 12 then
  vim.lsp.log.set_level("off")
  vim.diagnostic.enable(false)
elseif vim.version().minor >= 10 or vim.version.minor == 11 then
  ---@diagnostic disable-next-line: deprecated
  vim.lsp.set_log_level("off")
  vim.diagnostic.enable(false)
else
  ---@diagnostic disable-next-line: deprecated
  vim.lsp.set_log_level("off")
  ---@diagnostic disable-next-line: deprecated
  vim.diagnostic.disable()
end

-- stylua: ignore start
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
-- stylua: ignore end

-- globals
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.snacks_scope = false
vim.g.sidekick_nes = false
vim.b.sidekick_nes = false
vim.g.copilot_nes = false
vim.g.copilot_native = false
vim.g.ai_cmp = vim.env.LAZYVIM_AI_CMP ~= nil
vim.g.lazyvim_picker = vim.env.LAZYVIM_PICKER or "snacks" -- "telescope", "fzf", or "snacks"
vim.g.lazyvim_cmp = vim.env.LAZYVIM_CMP or "blink.cmp" -- or "nvim-cmp" for cmp, "blink.cmp" for blink, "auto" for default
vim.g.lazyvim_blink_main = false
vim.g.always_show_gitsigns = false
vim.g.cmp_disabled = false
vim.g.cmp_disabled_filetypes = { "TelescopePrompt", "neorepl", "snacks_picker_input" }
vim.g.focus_mode = vim.env.LAZYVIM_DISABLE_FOCUS_MODE == nil and true or false
vim.g.focus_mode_no_copilot = vim.env.LAZYVIM_DISABLE_FOCUS_MODE_COPILOT == nil
  or vim.env.LAZYVIM_DISABLE_FOCUS_MODE_COPILOT == "true"
vim.g.codecompanion_initial_adapter = vim.env.LAZYVIM_CODECOMPANION_ADAPTER or "copilot"
vim.g.codecompanion_initial_inline_adapter = vim.env.LAZYVIM_CODECOMPANION_INLINE_ADAPTER or "copilot"
vim.g.codecompanion_auto_tool_mode = nil
vim.g.lazyvim_python_lsp = "basedpyright"

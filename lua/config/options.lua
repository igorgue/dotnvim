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

vim.opt.clipboard = ""

if vim.o.diff ~= false then
  vim.opt.list = false
  vim.opt.wrap = false

  vim.opt.signcolumn = "no"
  vim.opt.cursorline = true
  vim.opt.number = true
end

-- sets the tabline to not show x, a very simple tabline
vim.cmd([[
  function NoXTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " select the highlighting
      if i + 1 == tabpagenr()
        let s ..= '%#TabLineSel#'
      else
        let s ..= '%#TabLine#'
      endif
      " set the tab page number (for mouse clicks)
      let s ..= '%' .. (i + 1) .. 'T'
      " the label is made by NoXTabLabel()
      let s ..= ' %{NoXTabLabel(' .. (i + 1) .. ')} '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s ..= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      " Does not include the close button
      let s ..= '%=%#TabLine#%999X'
    endif
    return s
  endfunction
  function NoXTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let name = fnamemodify(bufname(buflist[winnr - 1]), ":t")
    " Modification for no name...
    if name == ''
      return '[No Name]'
    endif
    return name
  endfunction
  set tabline=%!NoXTabLine()
]])

vim.diagnostic.config(utils.ui.diagnostic_config)
vim.lsp.set_log_level("off") -- change to "debug" to show many logs

if vim.version().minor >= 10 then
  vim.diagnostic.enable(false)
else
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
vim.g.ai_cmp = vim.env.LAZYVIM_AI_CMP ~= nil
vim.g.lazyvim_picker = vim.env.LAZYVIM_PICKER or "snacks" -- "telescope", "fzf", or "snacks"
vim.g.lazyvim_cmp = vim.env.LAZYVIM_CMP or "blink.cmp" -- or "nvim-cmp" for cmp, "blink.cmp" for blink, "auto" for default
vim.g.lazyvim_blink_main = false
vim.g.always_show_gitsigns = false
vim.g.cmp_disabled = false
vim.g.cmp_disabled_filetypes = { "TelescopePrompt", "neorepl", "snacks_picker_input" }
vim.g.focus_mode = vim.env.LAZYVIM_DISABLE_FOCUS_MODE == nil and true or false

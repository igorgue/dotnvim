-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local utils = require("utils")

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.list = false
vim.opt.spell = false
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = ""
vim.opt.timeout = true
vim.opt.timeoutlen = 250
vim.opt.pumblend = 4
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

vim.opt.signcolumn = "auto"
vim.opt.statuscolumn = ""

vim.diagnostic.config(utils.ui.diagnostic_config)
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, utils.ui.diagnostic_config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- stylua: ignore start
vim.fn.sign_define( "DapLogPoint", { text = " ", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define( "DapBreakpointCondition", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define( "DapBreakpointRejected", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
-- stylua: ignore end

-- globals
vim.g.autoformat = false

-- default tabs so I don't get surprised
vim.opt.shiftwidth=4
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.expandtab=true

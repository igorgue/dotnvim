-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local fn = vim.fn
local g = vim.g
local utils = require("utils")

opt.number = false
opt.relativenumber = false
opt.list = false
opt.wrap = true
opt.showbreak = "↪ "
opt.timeout = true
opt.timeoutlen = 250
opt.pumblend = 4
opt.backspace = { "indent", "eol", "start" }
opt.scrolloff = 3
opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize" }
opt.diffopt = {
  algorithm = "histogram",
  linematch = 60,
  "internal",
  "indent-heuristic",
  "filler",
  "closeoff",
  "iwhite",
  "vertical",
}
opt.shada = { "!", "'10", "/100", ":100", "<0", "@1", "f1", "h", "s1" }
opt.listchars = {
  tab = "──",
  -- "lead:·",
  trail = "·",
  nbsp = "␣",
  -- "eol:↵",
  precedes = "«",
  extends = "»",
}
opt.fillchars = {
  -- "vert:▏",
  vert = "│",
  diff = "╱",
  foldclose = "",
  foldopen = "",
  fold = " ",
  msgsep = "─",
  eob = " ",
}
opt.writebackup = true
opt.undofile = true
opt.isfname:append(":")
opt.clipboard = "unnamed"

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

-- FIXME: Figure out a way to get the space back
-- when disabling number with nonumber
-- * we cannot use number and relativenumber with this setup
if vim.version().minor == 9 then
  vim.opt.statuscolumn = "%=%l%r%s%C"
end

diagnostic.config(utils.ui.diagnostic_config)
lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(lsp.diagnostic.on_publish_diagnostics, utils.ui.diagnostic_config)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticError" })
fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarning" })
fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInformation" })
fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticHint" })
fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
-- stylua: ignore start
fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
-- stylua: ignore end

-- dart
g.dart_style_guide = 2
g.dart_html_in_string = true
g.dart_trailing_comma_indent = true
g.dartfmt_options = { "--fix" }

-- dadbod
g.dbs = {}
g.db_ui_use_nerd_fonts = true
g.db_ui_save_location = fn.stdpath("data") .. "/db_ui"

-- rust
g.rustfmt_autosave = false
g.rust_clip_command = "xclip -selection clipboard"

-- indent blankline
g.indent_blankline_disable_with_nolist = true
g.indent_blankline_use_treesitter = true

-- indent scope
g.miniindentscope_disable = true

-- copilot
g.copilot_filetypes = {
  TelescopeResults = false,
  TelescopePrompt = false,
}

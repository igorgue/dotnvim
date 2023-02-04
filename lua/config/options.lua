-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local fn = vim.fn

opt.number = false
opt.relativenumber = false
opt.list = false

local diagnostic_config = {
  float = { border = "rounded" },
  underline = true,
  virtual_text = {
    spacing = 0,
    prefix = "",
  },
  signs = true,
  update_in_insert = true,
  severity_sort = true,
}

diagnostic.config(diagnostic_config)
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, diagnostic_config)
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" })

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarning" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticHint" })

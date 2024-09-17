vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.opt_local.foldignore = "#"
vim.opt_local.foldmethod = "manual"

vim.lsp.start({
  init_options = {},
  name = "nim_langserver",
  filetypes = { "nim" },
  cmd = { "nimlangserver" },
  root_dir = vim.fn.getcwd(),
  single_file_support = true,
  settings = {},
})

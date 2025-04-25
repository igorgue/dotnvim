vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.lsp.start({
  init_options = {},
  name = "mojo",
  filetypes = { "mojo" },
  cmd = { "mojo-lsp-server" },
  root_dir = vim.fn.getcwd(),
  single_file_support = true,
  settings = {},
})

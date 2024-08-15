vim.lsp.start({
  init_options = {},
  name = "gleam",
  filetypes = { { "gleam" } },
  cmd = { "gleam", "lsp" },
  root_dir = vim.fn.getcwd(),
  single_file_support = true,
  settings = {},
})

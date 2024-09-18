vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true

vim.lsp.start({
  init_options = {},
  name = "zls",
  filetypes = { "zig", "zir" },
  cmd = { "zls" },
  root_dir = vim.fn.getcwd(),
  single_file_support = true,
  settings = {
    zls = {
      semantic_tokens = "full",
      warn_style = true,
      highlight_global_var_declarations = true,
      enable_snippets = true,
      enable_autofix = true,
      -- NOTE: never seen an inlay hint
      -- and I don't know what record_session does
      -- nor dangerous_comptime_experiments_do_not_enable...
      enable_inlay_hints = true,
      inlay_hints_show_builtin = true,
      inlay_hints_exclude_single_argument = true,
      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_hide_redundant_param_names_last_token = true,
      skip_std_references = true,
      record_session = true,
    },
  },
})

vim.g.zig_fmt_autosave = 0 -- handled by lsp

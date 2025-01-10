vim.b.indent_blankline_enabled = false

if LazyVim.has("cmp") then
  require("cmp").setup.buffer({ enabled = false })
end

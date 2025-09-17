vim.b.indent_blankline_enabled = false

-- Check if nvim-cmp is available using pcall to avoid errors
local ok, cmp = pcall(require, "cmp")
if ok then
  cmp.setup.buffer({ enabled = false })
end

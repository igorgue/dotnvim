vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ssa" },
  nested = true,
  callback = function()
    vim.bo.filetype = "qbe"
  end,
})

return {
  "perillo/qbe.vim",
  ft = { "qbe", "ssa" },
}

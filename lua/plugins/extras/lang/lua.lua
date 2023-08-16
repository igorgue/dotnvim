return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.highlight.disable) == "table" then
      vim.list_extend(opts.highlight.disable, { "lua" })
    else
      opts.highlight.disable = { "lua" }
    end

    if type(opts.indent.disable) == "table" then
      vim.list_extend(opts.indent.disable, { "lua" })
    else
      opts.indent.disable = { "lua" }
    end
  end,
}

return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "objective-c", "objective-cpp" },
    opts = function(_, opts)
      if vim.fn.executable("sourcekit-lsp") ~= 1 then
        return
      end

      opts.servers = {
        sourcekit = {},
      }

      return opts
    end,
  },
}

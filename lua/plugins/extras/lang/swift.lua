return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "objective-c", "objective-cpp" },
    -- stylua: ignore
    opts = function(_, opts)
      if vim.fn.executable("sourcekit-lsp") ~= 1 then return end

      opts.servers = {
        sourcekit = {},
      }
    end,
  },
}

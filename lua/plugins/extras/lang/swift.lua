return {
  {
    "neovim/nvim-lspconfig",
    ft = { "swift", "objective-c", "objective-cpp" },
    cond = function()
      return vim.fn.executable("sourcekit-lsp") == 1 and vim.fn.has("mac") == 1
    end,
    opts = {
      servers = {
        sourcekit = {},
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    cond = function()
      return vim.fn.executable("swiftlint")
    end,
    opts = function(_, opts)
      local nls = require("null-ls")

      opts.sources[#opts.sources + 1] = nls.builtins.formatting.swiftlint
      opts.sources[#opts.sources + 1] = nls.builtins.diagnostics.swiftlint

      return opts
    end,
  },
}

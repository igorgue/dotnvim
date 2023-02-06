return {
  "jose-elias-alvarez/null-ls.nvim",
  lazy = true,
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        nls.builtins.formatting.prettierd,
        nls.builtins.formatting.stylua,
        nls.builtins.diagnostics.pylint,
      },
    }
  end,
}

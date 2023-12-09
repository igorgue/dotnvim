return {
  {
    "stevearc/conform.nvim",
    opts = {
      format = {
        timeout_ms = 5000,
        async = false,
        lsp_fallback = true,
        quiet = true,
      },
      formatters_by_ft = {
        htmldjango = { "rustywind", "htmlbeautifier" },
        xml = { "htmlbeautifier" },
        html = { "rustywind", "htmlbeautifier" },
        elixir = { "mix" },
        rust = { "rustfmt" },
        python = { "black", "isort", "ruff_format", "ruff_fix" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        zsh = { "shfmt" },
        lua = { "stylua" },
      },
    },
    -- stylua: ignore
    keys = function() return {} end,
  },
}

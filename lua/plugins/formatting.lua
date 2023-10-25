return {
  {
    "stevearc/conform.nvim",
    opts = {
      format = {
        timeout_ms = 5000,
        async = false,
        lsp_fallback = "always",
        quiet = true,
      },
      formatters_by_ft = {
        html = { "rustywind" },
        elixir = { "mix" },
        rust = { "rustfmt" },
        python = { "black", "isort", "ruff_format", "ruff_fix" },
        zsh = { "shfmt" },
        lua = { "stylua" },
      },
    },
  },
}

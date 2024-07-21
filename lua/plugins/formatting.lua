return {
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 5000,
        async = false,
        lsp_fallback = true,
        quiet = true,
      },
      formatters_by_ft = {
        htmldjango = { "rustywind", "htmlbeautifier", "djlint", "curlylint" },
        heex = { "rustywind", "htmlbeautifier" },
        xml = { "htmlbeautifier" },
        html = { "rustywind", "htmlbeautifier" },
        elixir = { "rustywind", "mix" },
        rust = { "rustfmt" },
        python = { "black", "isort", "ruff_format", "ruff_fix" },
        javascript = { "prettier" },
        jsonc = { "prettier" },
        json = { "prettier" },
        typescript = { "prettier" },
        zsh = { "shfmt" },
        sh = { "shfmt" },
        lua = { "stylua" },
        ["*"] = { "trim_newlines", "trim_whitespace" },
      },
    },
    -- NOTE: I redefine these on keymaps.lua
    -- stylua: ignore
    keys = function() return {} end,
  },
}

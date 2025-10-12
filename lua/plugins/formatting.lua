return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "rustywind",
        "htmlbeautifier",
        "djlint",
        "curlylint",
        "jinja-lsp",
        "htmlbeautifier",
        "black",
        "isort",
        "ruff",
        "prettier",
        "shfmt",
        "stylua",
        "clang-format",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 5000,
        async = true,
        lsp_fallback = true,
        quiet = true,
      },
      formatters_by_ft = {
        htmldjango = { "rustywind", "htmlbeautifier", "djlint", "curlylint" },
        jinja = { "rustywind", "htmlbeautifier", "djlint" },
        heex = { "rustywind", "htmlbeautifier", "mix" },
        xml = { "htmlbeautifier" },
        html = { "rustywind", "htmlbeautifier" },
        elixir = { "rustywind", "mix" },
        rust = { "rustfmt" },
        python = { "black", "isort", "ruff_format", "ruff_fix" },
        javascript = { "prettier" },
        jsonc = { "prettier" },
        json = { "prettier" },
        typescript = { "prettier" },
        swift = { "swift_format" },
        zsh = { "shfmt" },
        sh = { "shfmt" },
        lua = { "stylua" },
        c = { "clang-format" },
        ["*"] = { "trim_newlines", "trim_whitespace" },
      },
    },
    -- NOTE: I redefine these on keymaps.lua
    -- stylua: ignore
    keys = function() return {} end,
  },
}

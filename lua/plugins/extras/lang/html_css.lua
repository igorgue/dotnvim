vim.treesitter.language.register("html", "jinja")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "html", "htmldjango" },
      indent = { enable = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- htmx = {},
        html = {
          filetypes = {
            "elixir",
            "eruby",
            "heex",
            "html",
            "htmldjango",
            "javascript",
            "javascriptreact",
            "jinja",
            "rust",
            "svelte",
            "typescript",
            "typescriptreact",
          },
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = "auto",
              },
            },
          },
        },
        cssls = {
          settings = { css = { lint = { unknownAtRules = "ignore" } } },
        },
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html", "htmldjango" })
      end

      vim.treesitter.language.register("html", "jinja")

      opts.indent = {
        enable = true,
      }

      return opts
    end,
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
        cssls = { settings = { css = { lint = { unknownAtRules = "ignore" } } } },
      },
    },
  },
}

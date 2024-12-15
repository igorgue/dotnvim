return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html", "htmldjango" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "html", "htmldjango", "css" },
    opts = {
      servers = {
        -- htmx = {},
        html = {
          filetypes = {
            "html",
            "htmldjango",
            "elixir",
            "heex",
            "eruby",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "rust",
            "svelte",
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

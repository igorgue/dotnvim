return {
  {
    "neovim/nvim-lspconfig",
    ft = { "html", "css", "javascript", "typescript", "rust", "elixir", "heex" },
    opts = {
      servers = {
        html = {
          format = {
            templating = true,
            wrapLineLength = 120,
            wrapAttributes = "auto",
          },
          filetypes = {
            "html",
            -- "heex",
            -- "elixir",
            -- "eruby",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "rust",
            "svelte",
          },
        },
        cssls = {},
        tailwindcss = {
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              eruby = "erb",
              heex = "phoenix-heex",
              svelte = "html",
              rust = "html",
            },
          },
          handlers = {
            ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
              vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
            end,
          },
          settings = {
            includeLanguages = {
              typescript = "javascript",
              typescriptreact = "javascript",
              ["html-eex"] = "html",
              ["phoenix-heex"] = "html",
              heex = "html",
              eelixir = "html",
              elixir = "html",
              elm = "html",
              erb = "html",
              svelte = "html",
              rust = "html",
            },
            tailwindCSS = {
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
              experimental = {
                classRegex = {
                  [[class= "([^"]*)]],
                  [[class: "([^"]*)]],
                  '~H""".*class="([^"]*)".*"""',
                  '~F""".*class="([^"]*)".*"""',
                },
              },
              validate = true,
            },
          },
          filetypes = {
            "css",
            "scss",
            "sass",
            "html",
            "heex",
            "elixir",
            "eruby",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "rust",
            "svelte",
          },
        },
      },
    },
  },
}

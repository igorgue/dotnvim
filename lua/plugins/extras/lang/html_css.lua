return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "html" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "html", "htmldjango", "css", "elixir", "heex" },
    opts = {
      servers = {
        htmx = {},
        html = {
          filetypes = {
            "html",
            "htmldjango",
            -- "heex",
            -- "elixir",
            -- "eruby",
            -- "javascript",
            "javascriptreact",
            -- "typescript",
            "typescriptreact",
            -- "rust",
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
        tailwindcss = {
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              eruby = "erb",
              heex = "phoenix-heex",
              svelte = "html",
              htmldjango = "html",
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
              -- rust = "html",
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
            "htmldjango",
            "heex",
            "elixir",
            "eruby",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            -- "rust",
            "svelte",
          },
        },
      },
    },
  },
}

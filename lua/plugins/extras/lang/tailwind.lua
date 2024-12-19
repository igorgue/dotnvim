return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes = {
            "css",
            "jinja",
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
            "rust",
            "svelte",
          },
          init_options = {
            userLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
          },
          settings = {
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
                  '"([^"]*)"',
                },
              },
              validate = true,
            },
          },
        },
      },
    },
  },
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tailwindcss-language-server" })
    end,
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = {
          "luckasRanarison/tailwind-tools.nvim",
          "onsails/lspkind-nvim",
        },
        opts = function(_, opts)
          opts.formatting = {
            format = require("lspkind").cmp_format({
              before = require("tailwind-tools.cmp").lspkind_format,
            }),
          }

          return opts
        end,
      },
    },
    opts = {
      document_color = {
        kind = "background",
      },
    },
  },
}

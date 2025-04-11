return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "c", "cpp" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "clangd", "clang-format", "codelldb" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    dependencies = {
      {
        "p00f/clangd_extensions.nvim",
        config = function(plugin)
          local register_keys_and_cmp = function()
            local wk = require("which-key")
            local bufnr = vim.api.nvim_get_current_buf()

            wk.add({
              { "<leader>cc", group = "c" },
              {
                "<leader>ccr",
                "<cmd>ClangdSwitchSourceHeader<cr>",
                desc = "Switch Source/Header",
              },
              { "<leader>cca", "<cmd>ClangdAST<cr>", desc = "Display AST" },
              {
                "<leader>cch",
                "<cmd>ClangdToggleInlayHints<cr>",
                desc = "Toggle Inlay Hints",
              },
              {
                "<leader>cct",
                "<cmd>ClangdTypeHierarchy<cr>",
                desc = "Display Type Hierarchy",
              },
              {
                "<leader>ccm",
                "<cmd>ClangdMemoryUsage<cr>",
                desc = "Display Memory Usage",
              },
              {
                "<leader>ccs",
                "<cmd>ClangdSymbolInfo<cr>",
                desc = "Display Symbol Info",
              },
              {
                "<leader>ccc",
                "<cmd>ClangdCallHierarchy<cr>",
                desc = "Display Call Hierarchy",
              },
            }, {
              buffer = bufnr,
            })
          end

          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "h", "hpp" },
            callback = register_keys_and_cmp,
          })

          return true
        end,
        keys = {},
        opts = {
          inlay_hints = {
            inline = vim.fn.has("nvim-0.10") == 1,
            highlight = "CopilotSuggestion",
          },
          ast = {
            role_icons = {
              type = " ",
              declaration = " ",
              expression = " ",
              specifier = " ",
              statement = " ",
              ["template argument"] = " ",
            },

            kind_icons = {
              Compound = " ",
              Recovery = " ",
              TranslationUnit = " ",
              PackExpansion = " ",
              TemplateTypeParm = " ",
              TemplateTemplateParm = " ",
              TemplateParamObject = " ",
            },
            highlights = {
              detail = "CopilotSuggestion",
            },
          },
        },
      },
    },
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities = {
            offsetEncoding = { "utf-16" },
          }
        end,
      },
    },
  },
}

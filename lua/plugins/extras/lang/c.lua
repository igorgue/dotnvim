return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "c", "cpp" },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c", "cpp" })
      else
        opts.ensure_installed = { "c", "cpp" }
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "codelldb" })
      end
    end,
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

            ---@diagnostic disable-next-line: missing-fields
            if LazyVim.has("cmp") then
              local cmp = require("cmp")

              cmp.setup({
                ---@diagnostic disable-next-line: missing-fields
                sorting = {
                  comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.recently_used,
                    require("clangd_extensions.cmp_scores"),
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                  },
                },
              })
            end

            wk.add({
              { "<leader>cc", group = "c" },
              { "<leader>ccr", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header" },
              { "<leader>cca", "<cmd>ClangdAST<cr>", desc = "Display AST" },
              { "<leader>cch", "<cmd>ClangdToggleInlayHints<cr>", desc = "Toggle Inlay Hints" },
              { "<leader>cct", "<cmd>ClangdTypeHierarchy<cr>", desc = "Display Type Hierarchy" },
              { "<leader>ccm", "<cmd>ClangdMemoryUsage<cr>", desc = "Display Memory Usage" },
              { "<leader>ccs", "<cmd>ClangdSymbolInfo<cr>", desc = "Display Symbol Info" },
              { "<leader>ccc", "<cmd>ClangdCallHierarchy<cr>", desc = "Display Call Hierarchy" },
            }, {
              buffer = bufnr,
            })
          end

          vim.api.nvim_create_autocmd(
            "FileType",
            { pattern = { "c", "cpp", "h", "hpp" }, callback = register_keys_and_cmp }
          )

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
          -- memory_usage = {
          --   border = "single",
          -- },
          -- symbol_info = {
          --   border = "single",
          -- },
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

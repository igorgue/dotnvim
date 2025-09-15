return {
  {
    "neovim/nvim-lspconfig",
    ft = { "dart" },
    opts = {
      servers = {
        dartls = false,
      },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    -- stylua: ignore
    enabled = not vim.o.diff,
    dependencies = {
      "dart-lang/dart-vim-plugin",
      "Nash0x7E2/awesome-flutter-snippets",
    },
    opts = {
      ui = {
        -- border = "single",
        notification_style = "native",
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        enabled = true,
        prefix = "  ",
      },
      outline = {
        open_cmd = "botright 40vnew",
        auto_open = false,
      },
      dev_log = {
        enabled = true,
        open_cmd = "botright 5sp",
      },
      lsp = {
        on_attach = function()
          local register_keys = function()
            local wk = require("which-key")
            local bufnr = vim.api.nvim_get_current_buf()

            wk.add({
              {
                "<leader>o",
                "<cmd>FlutterOutlineToggle<cr>",
                desc = "Flutter Outline",
              },
            }, {
              buffer = bufnr,
            })

            wk.add({
              { "<leader>cD", group = "dart" },
              { "<leader>cDr", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
              {
                "<leader>cDR",
                "<cmd>FlutterRestart<cr>",
                desc = "Flutter Restart",
              },
              {
                "<leader>cDp",
                "<cmd>FlutterPubGet<cr>",
                desc = "Flutter Pub Get",
              },
              {
                "<leader>cDP",
                "<cmd>FlutterPubUpgrade<cr>",
                desc = "Flutter Pub Upgrade",
              },
            }, {
              buffer = bufnr,
            })
          end

          vim.api.nvim_create_autocmd("FileType", { pattern = "dart", callback = register_keys })

          require("telescope").load_extension("flutter")
        end,
        color = {
          enabled = true,
          background = true,
        },
        settings = {
          showTodos = false,
          completeFunctionCalls = true,
          updateImportsOnRename = true,
          enableSnippets = true,
          renameFilesWithClasses = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        exception_breakpoints = {},
        register_configurations = function(_)
          require("dap").configurations.dart = {}
          require("dap.ext.vscode").load_launchjs()
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.adapters.dart = {
        type = "executable",
        command = "flutter",
        args = { "debug-adapter" },
      }

      dap.configurations.dart = {}
      require("dap.ext.vscode").load_launchjs()
    end,
  },
}

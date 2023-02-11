return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "dart-lang/dart-vim-plugin",
      "Nash0x7E2/awesome-flutter-snippets",
    },
    opts = {
      ui = {
        border = "rounded",
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
        on_attach = function(_, _)
          require("lazyvim.util").on_attach(function(client, bufnr)
            local which_key = require("which-key")
            local nvim_del_keymap = vim.api.nvim_del_keymap

            pcall(nvim_del_keymap, "n", "<leader>cR")
            pcall(nvim_del_keymap, "n", "<leader>cF")
            pcall(nvim_del_keymap, "n", "<leader>cp")
            pcall(nvim_del_keymap, "n", "<leader>cP")

            which_key.register({
              c = {
                R = { "<cmd>FlutterRun<cr>", "Flutter run" },
                F = { "<cmd>FlutterRestart<cr>", "Flutter restart" },
                p = { "<cmd>FlutterPubGet<cr>", "Flutter pub get" },
                P = { "<cmd>FlutterPubUpgrade<cr>", "Flutter pub upgrade" },
              },
            }, {
              prefix = "<leader>",
            })

            require("telescope").load_extension("flutter")
            require("flutter-tools").on_attach(client, bufnr)
          end)
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
}

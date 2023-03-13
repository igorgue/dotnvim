return {
  {
    "neovim/nvim-lspconfig",
    ft = { "dart" },
    opts = {
      setup = {
        -- stylua: ignore
        dartls = function() return true end,
      },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      {
        "dart-lang/dart-vim-plugin",
        init = function()
          vim.g.dart_style_guide = 2
          vim.g.dart_html_in_string = true
          vim.g.dart_trailing_comma_indent = true
          vim.g.dartfmt_options = { "--fix" }
        end,
      },
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
        on_attach = function()
          local register_keys = function()
            local wk = require("which-key")

            wk.register({
              c = {
                R = { "<cmd>FlutterRun<cr>", "Flutter run" },
                F = { "<cmd>FlutterRestart<cr>", "Flutter restart" },
                p = { "<cmd>FlutterPubGet<cr>", "Flutter pub get" },
                P = { "<cmd>FlutterPubUpgrade<cr>", "Flutter pub upgrade" },
                o = { "<cmd>FlutterOutlineToggle<cr>", "Flutter outline" },
              },
            }, {
              prefix = "<leader>",
              buffer = vim.api.nvim_get_current_buf(),
            })
          end

          register_keys()
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
}

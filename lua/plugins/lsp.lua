return {
  {
    "SmiteshP/nvim-navic",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keymaps = require("lazyvim.plugins.lsp.keymaps")
      local ui_windows = require("lspconfig.ui.windows")
      local format = require("lazyvim.plugins.lsp.format").format

      keymaps._keys = {
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
        { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover doc" },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action", mode = { "n", "v" } },
        { "<leader>cc", "<cmd>Lspsaga lsp_finder<cr>", desc = "Finder" },
        { "<leader>cD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
        { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        -- stylua: ignore
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting", },
        { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
        { "<leader>cL", vim.lsp.codelens.run, desc = "Run codelense" },
        { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Diagnostics next" },
        { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Diagnostics prev" },
        { "[e", keymaps.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
        { "]e", keymaps.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
        { "[w", keymaps.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
        { "]w", keymaps.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      }

      ui_windows.default_options.border = "rounded"

      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      opts.servers.cssls = {}

      opts.servers.tailwindcss = {
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
      }

      -- opts.servers.html = {
      --   filetypes = {
      --     "html",
      --     "heex",
      --     "elixir",
      --     "eruby",
      --     "javascript",
      --     "javascriptreact",
      --     "typescript",
      --     "typescriptreact",
      --     "rust",
      --     "svelte",
      --   },
      -- }

      opts.servers.sumneko_lua = {
        settings = {
          Lua = {
            codeLens = {
              enable = true,
            },
            hint = {
              enable = true,
              setType = true,
            },
            completion = {
              callSnippets = "Replace",
            },
          },
        },
      }

      return opts
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      require("lspsaga").setup(opts)

      require("lazyvim.util").on_attach(function(_, _)
        local keymap = vim.keymap

        pcall(function()
          vim.api.nvim_del_keymap("n", "<leader>co")
        end)

        if vim.bo.filetype == "dart" then
          keymap.set(
            "n",
            "<leader>co",
            "<cmd>FlutterOutlineToggle<cr>",
            { buffer = true, noremap = true, silent = true }
          )

          return
        end

        keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<cr>", { silent = true })
      end)
    end,
    opts = {
      ui = {
        theme = "round",
        border = "rounded",
        code_action = " ",
        -- winblend = 20,
        colors = {
          normal_bg = "#161925",
          title_bg = "#afd7af",
          red = "#ff3525",
          magenta = "#875fff",
          orange = "#ff5f00",
          yellow = "#ffd75f",
          green = "#00af87",
          cyan = "#cbe6ff",
          blue = "#8787d7",
          purple = "#875fff",
          white = "#875fff",
          black = "#626262",
        },
      },
      lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        virtual_text = false,
      },
      rename = {
        quit = "<esc>",
        exec = "<CR>",
        in_select = false,
      },
      symbol_in_winbar = {
        enable = false,
        show_file = false,
        click_support = function(node, clicks, button, modifiers)
          -- To see all avaiable details: vim.pretty_print(node)
          local st = node.range.start
          local en = node.range["end"]
          local fn = vim.fn

          if button == "l" then
            if clicks == 2 then
              -- double left click to do nothing
            else -- jump to node's starting line+char
              fn.cursor({ st.line + 1, st.character + 1 })
            end
          elseif button == "r" then
            if modifiers == "s" then
              print("lspsaga") -- shift right click to print "lspsaga"
            end -- jump to node's ending line+char
            fn.cursor({ en.line + 1, en.character + 1 })
          elseif button == "m" then
            -- middle click to visual select node
            fn.cursor({ st.line + 1, st.character + 1 })
            vim.cmd("normal v")
            fn.cursor({ en.line + 1, en.character + 1 })
          end
        end,
      },
      outline = {
        auto_preview = false,
        auto_enter = false,
        auto_refresh = false,
      },
      finder = {
        max_height = 0.8,
      },
    },
    keys = {
      { "<leader>co", nil, desc = "Code outline" },
    },
  },
  {
    "mhanberg/elixir.nvim",
    dependencies = {
      "elixir-editors/vim-elixir",
    },
    priority = 9001,
    config = function()
      local elixir = require("elixir")

      elixir.setup({
        -- specify a repository and branch
        repo = "elixir-lsp/elixir-ls",
        branch = "master",
        -- repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls

        -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
        -- cmd = { home .. "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },

        -- default settings, use the `settings` function to override settings
        settings = require("elixir").settings({
          dialyzerEnabled = true,
          dialyzerFormat = "dialyxir_long",
          -- dialyzerWarnOpts = []
          enableTestLenses = true,
          -- envVariables =
          fetchDeps = true,
          -- languageServerOverridePath =
          mixEnv = "dev",
          -- mixTarget = "host",
          -- projectDir = "",
          signatureAfterComplete = true,
          suggestSpecs = true,
          trace = {
            server = "on",
          },
        }),
        on_attach = function(_, _)
          require("lazyvim.util").on_attach(function(_, bufnr)
            local keymap = vim.keymap
            local elixir_opts = { noremap = true, silent = true, buffer = bufnr }

            -- remove the pipe operator
            keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", elixir_opts)

            -- add the pipe operator
            keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", elixir_opts)
            keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", elixir_opts)
          end)
        end,
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    priority = 9001,
    opts = {
      tools = {
        executor = function()
          require("rust-tools.executors").quickfix()
        end,
      },
      server = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        standalone = true,
        assist = {
          emitMustUse = true,
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
        check = {
          features = "all",
          extraArgs = { "--target-dir", "/home/igor/Code/tmp/rust-analyzer" },
        },
        diagnostics = {
          experimental = {
            enable = true,
          },
        },
        hover = {
          actions = {
            references = {
              enable = true,
            },
          },
        },
        lens = {
          references = {
            enumVariant = {
              enable = true,
            },
            method = {
              enable = true,
            },
            trait = {
              enable = true,
            },
            adt = {
              enable = true,
            },
          },
        },
        rustfmt = {
          rangeFormatting = {
            enable = true,
          },
        },
        semanticHighlighting = {
          operator = {
            enable = true,
          },
          strings = {
            enable = true,
          },
          doc = {
            comment = {
              inject = {
                enable = true,
              },
            },
          },
          punctuation = {
            enable = true,
            separate = {
              macro = {
                bang = true,
              },
            },
            specialization = {
              enable = true,
            },
          },
          specialization = {
            enable = true,
          },
        },
        trace = {
          server = "verbose",
          extension = true,
        },
        typing = {
          autoClosingAngleBrackets = {
            enable = true,
          },
        },
      },
      dap = {
        adapter = {
          type = "executable",
          command = "codelldb",
          name = "codelldb",
        },
      },
    },
  },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    priority = 9001,
    config = function()
      require("crates").setup()
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    priority = 9001,
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
            pcall(function()
              vim.api.nvim_del_keymap("n", "<leader>co")
            end)

            vim.keymap.set(
              "n",
              "<leader>co",
              ":FlutterOutlineToggle<CR>",
              { buffer = true, noremap = true, silent = true }
            )

            require("telescope").load_extension("flutter")
            require("flutter-tools").lsp_on_attach(client, bufnr)
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
          enableSnippets = false,
          renameFilesWithClasses = true,
        },
      },
      -- debugger = {
      --   enabled = true,
      --   run_via_dap = true,
      --   exception_breakpoints = {},
      --   register_configurations = function(_)
      --     require("dap").configurations.dart = {}
      --     require("dap.ext.vscode").load_launchjs()
      --   end,
      -- },
    },
  },
}

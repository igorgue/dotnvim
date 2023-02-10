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
        { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover doc", silent = true },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action", mode = { "n", "v" } },
        { "<leader>cc", "<cmd>Lspsaga lsp_finder<cr>", desc = "Finder" },
        { "<leader>cD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
        { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        -- stylua: ignore
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting", },
        { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
        { "<leader>cL", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cl", vim.lsp.codelens.run, desc = "Run codelens" },
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

      opts.servers.html = {
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
      }

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

      opts.setup.clangd = function(_, clangd_opts)
        clangd_opts.capabilities.offsetEncoding = { "utf-8" }
      end

      return opts
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(client, opts)
      local keymap = vim.keymap
      local default_opts = { silent = true, noremap = true }

      require("lspsaga").setup(opts)

      pcall(vim.api.nvim_del_keymap, "n", "<leader>co")

      -- TODO: This doesn't belong here
      if client.name == "dartls" then
        keymap.set("n", "<leader>co", "<cmd>FlutterOutlineToggle<cr>", default_opts)
      else
        keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<cr>", default_opts)
      end
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
    lazy = false,
    priority = 40,
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
            local which_key = require("which-key")
            local elixir_opts = { noremap = true, silent = true, buffer = bufnr }
            local nvim_del_keymap = vim.api.nvim_del_keymap

            pcall(nvim_del_keymap, "n", "<leader>cp")
            pcall(nvim_del_keymap, "n", "<leader>cP")
            pcall(nvim_del_keymap, "n", "<leader>cm")
            pcall(nvim_del_keymap, "n", "<leader>cR")
            pcall(nvim_del_keymap, "n", "<leader>cO")

            which_key.register({
              c = {
                p = { "<cmd>ElixirToPipe<cr>", "Elixir to pipe", opts = elixir_opts },
                P = { "<cmd>ElixirFromPipe<cr>", "Elixir from pipe", opts = elixir_opts },
                m = { "<cmd>ElixirExpandMacro<cr>", "Elixir expand macro", opts = elixir_opts },
                R = { "<cmd>ElixirRestart<cr>", "Elixir restart", opts = elixir_opts },
                O = { "<cmd>ElixirOutputPanel<cr>", "Elixir LSP output panel", opts = elixir_opts },
              },
            }, {
              prefix = "<leader>",
            })
          end)
        end,
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "rust-lang/rust.vim",
    },
    lazy = false,
    priority = 40,
    opts = {
      tools = {
        executor = function()
          require("rust-tools.executors").quickfix()
        end,
        reload_workspace_from_cargo_toml = true,
        on_initialized = function(status)
          if status.health ~= "ok" then
            vim.notify("rust-tools: initialized, status: " .. vim.inspect(status), vim.log.levels.ERROR)

            return
          end
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
        on_attach = function()
          local rt = require("rust-tools")

          rt.inlay_hints.enable()

          require("lazyvim.util").on_attach(function(_, bufnr)
            local which_key = require("which-key")
            local keymap = vim.keymap
            local api = vim.api
            local nvim_del_keymap = api.nvim_del_keymap
            local map_opts = { noremap = true, silent = true, buffer = bufnr }

            pcall(nvim_del_keymap, "n", "K")
            pcall(nvim_del_keymap, "v", "K")
            pcall(nvim_del_keymap, "n", "<C-k>")
            pcall(nvim_del_keymap, "n", "<leader>cA")
            pcall(nvim_del_keymap, "n", "<leader>cR")
            pcall(nvim_del_keymap, "n", "<leader>ce")
            pcall(nvim_del_keymap, "n", "<leader>cm")
            pcall(nvim_del_keymap, "n", "<leader>cM")
            pcall(nvim_del_keymap, "n", "<leader>cC")
            pcall(nvim_del_keymap, "n", "<leader>cp")
            pcall(nvim_del_keymap, "n", "<leader>cj")

            keymap.set("n", "K", rt.hover_actions.hover_actions, map_opts)
            keymap.set("v", "K", rt.hover_range.hover_range, map_opts)
            keymap.set("n", "<C-k>", "<cmd>Lspsaga hover_doc<cr>", map_opts)

            which_key.register({
              c = {
                A = { rt.code_action_group.code_action_group, "Rust code actions", opts = map_opts },
                R = { rt.runnables.runnables, "Rust runables", opts = map_opts },
                e = { rt.expand_macro.expand_macro, "Rust expand macro", opts = map_opts },
                -- stylua: ignore
                m = { function() rt.move_item.move_item(true) end, "Rust move up", opts = map_opts },
                -- stylua: ignore
                M = { function() rt.move_item.move_item(false) end, "Rust move down", opts = map_opts},
                C = { rt.open_cargo_toml.open_cargo_toml, "Rust open cargo.toml", opts = map_opts },
                p = { rt.parent_module.parent_module, "Rust parent module", opts = map_opts },
                j = { rt.join_lines.join_lines, "Rust join lines", opts = map_opts },
              },
            }, {
              prefix = "<leader>",
            })
          end)
        end,
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
    config = true,
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    priority = 40,
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
  {
    "raimon49/requirements.txt.vim",
    event = "VeryLazy",
  },
}

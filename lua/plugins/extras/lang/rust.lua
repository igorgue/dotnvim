return {
  {
    "neovim/nvim-lspconfig",
    ft = { "rust" },
    opts = {
      setup = {
        -- stylua: ignore
        ["rust-analyzer"] = function() return true end,
      },
    },
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "rust-lang/rust.vim",
      init = function()
        vim.g.rustfmt_autosave = false
        vim.g.rust_clip_command = "xclip -selection clipboard"
      end,
    },
    ft = "rust",
    opts = {
      tools = {
        executor = function()
          require("rust-tools.executors").quickfix()
        end,
        reload_workspace_from_cargo_toml = true,
        on_initialized = function(status)
          if status.health ~= "ok" then
            vim.notify("rust-tools: failed, status: " .. vim.inspect(status), vim.log.levels.ERROR)

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
        cachePriming = {
          enable = true,
        },
        completion = {
          privateEditable = {
            enable = true,
          },
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
          autoreload = true,
        },
        procMacro = {
          enable = true,
        },
        check = {
          features = "all",
        },
        diagnostics = {
          experimental = {
            enable = true,
          },
          previewRustcOutput = true,
          useRustcErrorCode = true,
        },
        hover = {
          actions = {
            references = {
              enable = true,
            },
          },
        },
        imports = {
          granularity = {
            enforce = true,
          },
        },
        interpret = {
          tests = true,
        },
        inlayHints = {
          bindingModeHints = {
            enable = true,
          },
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
          reborrowHints = {
            enable = "always",
          },
          closureReturnTypeHints = {
            enable = "always",
          },
          discriminantHints = {
            enable = "always",
          },
          expressionAdjustmentHints = {
            enable = "always",
          },
          lifetimeElisionHints = {
            enable = "always",
            useParameterNames = true,
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
        debug = {
          openDebugPane = true,
        },
        restartServerOnConfigChange = true,
        rustfmt = {
          rangeFormatting = {
            enable = true,
          },
        },
        semanticHighlighting = {
          operator = {
            enable = true,
            specialization = {
              enable = true,
            },
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
          local register_keys = function()
            local rt = require("rust-tools")
            local wk = require("which-key")
            local keymap = vim.keymap
            local api = vim.api
            local nvim_del_keymap = api.nvim_del_keymap
            -- rust-tools replaces K and K in visual mode
            pcall(nvim_del_keymap, "n", "K")
            pcall(nvim_del_keymap, "v", "K")

            keymap.set("n", "K", rt.hover_actions.hover_actions)
            keymap.set("v", "K", rt.hover_range.hover_range)

            wk.register({
              c = {
                A = { rt.code_action_group.code_action_group, "Rust code actions" },
                R = { rt.runnables.runnables, "Rust runables" },
                e = { rt.expand_macro.expand_macro, "Rust expand macro" },
                -- stylua: ignore
                k = { function() rt.move_item.move_item(true) end, "Rust move up" },
                -- stylua: ignore
                j = { function() rt.move_item.move_item(false) end, "Rust move down"},
                C = { rt.open_cargo_toml.open_cargo_toml, "Rust open cargo.toml" },
                p = { rt.parent_module.parent_module, "Rust parent module" },
                J = { rt.join_lines.join_lines, "Rust join lines" },
              },
            }, {
              prefix = "<leader>",
              buffer = vim.api.nvim_get_current_buf(),
            })
          end

          require("rust-tools").inlay_hints.enable()

          register_keys()
          vim.api.nvim_create_autocmd("FileType", { pattern = "rust", callback = register_keys })
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
    event = "BufReadPost Cargo.toml",
    config = function(_, opts)
      require("crates").setup(opts)

      local register_keys_and_cmp = function()
        local cmp = require("cmp")
        local wk = require("which-key")

        cmp.setup.buffer({ sources = { { name = "crates" }, { name = "buffer" } } })
        wk.register({
          ["<cr>"] = { require("crates").show_popup, "Crates Popup" },
        }, {
          buffer = vim.api.nvim_get_current_buf(),
        })
      end

      register_keys_and_cmp()
      vim.api.nvim_create_autocmd("BufReadPost", { pattern = "Cargo.toml", callback = register_keys_and_cmp })
    end,
    opts = {
      null_ls = {
        enabled = true,
        name = "Crates",
      },
      popup = {
        autofocus = true,
        hide_on_select = true,
        border = "rounded",
      },
    },
  },
}

return {
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "rust-lang/rust.vim",
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
            pcall(nvim_del_keymap, "n", "<leader>cA")
            pcall(nvim_del_keymap, "n", "<leader>cR")
            pcall(nvim_del_keymap, "n", "<leader>ce")
            pcall(nvim_del_keymap, "n", "<leader>cj")
            pcall(nvim_del_keymap, "n", "<leader>ck")
            pcall(nvim_del_keymap, "n", "<leader>cC")
            pcall(nvim_del_keymap, "n", "<leader>cp")
            pcall(nvim_del_keymap, "n", "<leader>cJ")

            keymap.set("n", "K", rt.hover_actions.hover_actions, map_opts)
            keymap.set("v", "K", rt.hover_range.hover_range, map_opts)
            keymap.set("n", "<m-k>", "<cmd>Lspsaga hover_doc<cr>", map_opts)

            which_key.register({
              c = {
                A = { rt.code_action_group.code_action_group, "Rust code actions", opts = map_opts },
                R = { rt.runnables.runnables, "Rust runables", opts = map_opts },
                e = { rt.expand_macro.expand_macro, "Rust expand macro", opts = map_opts },
                -- stylua: ignore
                k = { function() rt.move_item.move_item(true) end, "Rust move up", opts = map_opts },
                -- stylua: ignore
                j = { function() rt.move_item.move_item(false) end, "Rust move down", opts = map_opts},
                C = { rt.open_cargo_toml.open_cargo_toml, "Rust open cargo.toml", opts = map_opts },
                p = { rt.parent_module.parent_module, "Rust parent module", opts = map_opts },
                J = { rt.join_lines.join_lines, "Rust join lines", opts = map_opts },
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
    event = "BufReadPost Cargo.toml",
    config = function(_, _)
      require("crates").setup()
      require("cmp").setup.buffer({ sources = { { name = "crates" }, { name = "buffer" } } })
    end,
  },
}

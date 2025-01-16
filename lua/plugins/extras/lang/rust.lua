return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Saecki/crates.nvim",
    },
    opts = {
      sources = {
        default = { "crates" },
        providers = {
          crates = {
            name = "crates",
            module = "blink.compat.source",
            opts = {},
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      "Saecki/crates.nvim",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    config = function(_, opts)
      require("crates").setup(opts)

      local register_keys = function()
        local wk = require("which-key")

        wk.add({
          { "<cr>", require("crates").show_popup, desc = "Crates Popup" },
        }, {
          buffer = vim.api.nvim_get_current_buf(),
        })
      end

      vim.api.nvim_create_autocmd(
        "BufReadPost",
        { pattern = "Cargo.toml", callback = register_keys }
      )
    end,
    opts = {
      completion = {
        cmp = {
          enabled = true,
        },
      },
      popup = {
        autofocus = true,
        hide_on_select = true,
        border = "rounded",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ron", "rust", "toml" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "codelldb" },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
      server = {
        on_attach = function(_, bufnr)
          -- register which-key mappings
          local wk = require("which-key")
          wk.add({
            {
              "<leader>ca",
              function()
                vim.cmd.RustLsp("codeAction")
              end,
              desc = "Code Actions (Rust)",
            },
            {
              "<leader>dr",
              function()
                vim.cmd.RustLsp("debuggables")
              end,
              desc = "Rust debuggables",
            },
          }, { mode = "n", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            assist = {
              emitMustUse = true,
            },
            completion = {
              privateEditable = {
                enable = true,
              },
            },
            diagnostics = {
              enable = false,
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
            cachePriming = {
              numThreads = 12,
            },
            numThreads = 12,
            check = {
              command = "clippy",
            },
            imports = {
              granularity = {
                enforce = true,
              },
              prefer = {
                no = {
                  std = true,
                },
              },
            },
            inlayHint = {
              dynamicRegistration = true,
              resolveSupport = {
                properties = {},
              },
            },
            interpret = {
              tests = true,
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
              overrideCommand = { "rustup", "run", "stable", "rustfmt" },
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
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        taplo = {
          keys = {
            {
              "K",
              function()
                if
                  vim.fn.expand("%:t") == "Cargo.toml"
                  and require("crates").popup_available()
                then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  },
}

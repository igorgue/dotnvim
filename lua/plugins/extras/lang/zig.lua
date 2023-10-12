return {
  {
    "ziglang/zig.vim",
    optional = true,
    init = function()
      vim.g.zig_fmt_autosave = 1

      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.zig.zon",
        callback = function()
          vim.bo.filetype = "zig"
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      {
        "ziglang/zig.vim",
        init = function()
          vim.g.zig_fmt_autosave = 1

          vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            pattern = "*.zig.zon",
            callback = function()
              vim.bo.filetype = "zig"
            end,
          })
        end,
      },
    },
    opts = {
      servers = {
        zls = {
          settings = {
            semantic_tokens = "full",
            warn_style = true,
            -- NOTE: never seen an inlay hint
            -- and I don't know what record_session does
            -- nor dangerous_comptime_experiments_do_not_enable...
            -- enable_inlay_hints = true,
            -- inlay_hints_show_builtin = true,
            -- inlay_hints_exclude_single_argument = true,
            -- inlay_hints_hide_redundant_param_names = true,
            -- inlay_hints_hide_redundant_param_names_last_token = true,
            -- highlight_global_var_declarations = true,
            -- dangerous_comptime_experiments_do_not_enable = true,
            -- record_session = true,
          },
        },
      },
    },
    {
      "mfussenegger/nvim-dap",
      opts = function()
        local dap = require("dap")
        dap.configurations["zig"] = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end,
    },
  },
}

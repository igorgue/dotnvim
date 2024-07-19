return {
  {
    "neovim/nvim-lspconfig",
    ft = "nim",
    opts = function(_, opts)
      opts.servers = {
        nim_langserver = {},
      }
    end,
  },
  {
    "alaviss/nim.nvim",
    ft = "nim",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "nim", "nim_format_string" })
      else
        opts.ensure_installed = { "nim", "nim_format_string" }
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local home = vim.env.HOME

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = {
          "-i",
          "dap",
          "-eval-command",
          "source " .. home .. "/.nim/tools/debug/nim-gdb.py",
        },
      }

      dap.configurations.nim = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            if vim.g.nim_dap_build_command ~= nil then
              vim.fn.system(vim.g.nim_dap_build_command)
            end

            if vim.g.nim_dap_program ~= nil then
              return vim.g.nim_dap_program
            end

            vim.g.nim_dap_program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")

            return vim.g.nim_dap_program
          end,
          args = function()
            if vim.g.nim_dap_argv ~= nil then
              return vim.g.nim_dap_argv
            end

            local argv = {}
            local arg = vim.fn.input("New Arguments: ", "", "file")

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Launch (new args)",
          type = "gdb",
          request = "launch",
          program = function()
            vim.g.nim_dap_program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")

            return vim.g.nim_dap_program
          end,
          args = function()
            local argv = {}
            local arg = vim.fn.input("New Arguments: ", "", "file")

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.nim_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["nim"] = { "nimpretty" },
      },
    },
  },
}

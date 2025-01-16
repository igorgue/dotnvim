return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        -- stylua: ignore start
        nim_langserver = function() return true end,
      },
    },
  },
  {
    "alaviss/nim.nvim",
    ft = "nim",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "nim", "nim_format_string" },
    },
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

            vim.g.nim_dap_program = vim.fn.input(
              "Path to executable: ",
              vim.fn.getcwd() .. "/",
              "file"
            )

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
            vim.g.nim_dap_program = vim.fn.input(
              "Path to executable: ",
              vim.fn.getcwd() .. "/",
              "file"
            )

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
    opts = {
      formatters_by_ft = {
        nim = { "nimpretty" },
      },
    },
  },
}

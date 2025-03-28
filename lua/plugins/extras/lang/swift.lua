return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.adapters.swift = {
        type = "executable",
        command = "lldb-dap",
        name = "swift",
      }

      dap.configurations["swift"] = {
        {
          name = "Launch Swift Executable",
          type = "swift",
          request = "launch",
          program = function()
            vim.fn.system("swift build -Xswiftc -g")

            if vim.b.swift_executable then
              return vim.b.swift_executable
            else
              vim.b.swift_executable = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/", "file")
            end

            return vim.b.swift_executable
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            if vim.b.swift_args then
              return vim.b.swift_args
            else
              vim.b.swift_args = { vim.fn.input("Arguments: ", "", "file") }
            end

            if vim.b.swift_args == "" then
              return {}
            else
              return vim.split(vim.b.swift_args, " ")
            end
          end,
        },
      }
    end,
  },
}

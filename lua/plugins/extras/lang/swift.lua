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

            if vim.g.swift_dap_executable then
              return vim.g.swift_dap_executable
            else
              vim.g.swift_dap_executable =
                vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/", "file")
            end

            return vim.g.swift_dap_executable
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            if vim.g.swift_dap_argv ~= nil then
              return vim.g.swift_dap_argv
            end

            local argv = {}
            local arg = vim.fn.input(string.format("Arguments: ", "", "file"))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.swift_dap_argv = argv

            return argv
          end,
        },
      }
    end,
  },
}

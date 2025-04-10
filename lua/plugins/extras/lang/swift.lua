vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    vim.opt_local.makeprg = "swift build -Xswiftc -g"
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "swift" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "swiftlint", "xcbeautify" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("sourcekit-lsp") ~= 1 then
        return
      end

      opts.servers.sourcekit = {}
    end,
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
            vim.cmd("make")

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

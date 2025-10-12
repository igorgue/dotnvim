return {
  desc = "Zig language support",
  { import = "lazyvim.plugins.extras.lang.zig" },
  { "ziglang/zig.vim", ft = "zig" },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        zig = { "zigfmt", lsp_format = "fallback" },
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
          name = "Run Zig program",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x zig-out/bin/"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            if vim.g.zig_dap_argv ~= nil then
              return vim.g.zig_dap_argv
            end

            local argv = {}
            local arg = vim.fn.input(string.format("Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.zig_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Run Zig program (new args)",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x zig-out/bin/"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          args = function()
            local argv = {}
            local arg = vim.fn.input(string.format("New Arguments: "))

            for a in string.gmatch(arg, "%S+") do
              table.insert(argv, a)
            end

            vim.g.zig_dap_argv = argv

            return argv
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
}

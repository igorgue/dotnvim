vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    local build_cmd = "swift build -Xswiftc -g"
    if vim.opt_local.makeprg == build_cmd then
      return
    end

    vim.opt_local.makeprg = build_cmd
  end,
})

vim.filetype.add({
  filename = {
    [".swift-format"] = "json",
    ["Package.resolved"] = "json",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "swift" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "xcbeautify" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      if vim.fn.executable("swift-format") ~= 1 then
        return
      end

      opts.linters_by_ft.swift = { "swift-format" }
      opts.linters["swift-format"] = function()
        return {
          cmd = "swift-format",
          args = { "lint", "-" },
          stdin = true,
          parser = require("lint.parser").from_pattern(
            "^([^:]+):(%d+):(%d+): (%w+): (.*)$",
            { "filename", "lnum", "col", "severity", "message" },
            {
              error = vim.diagnostic.severity.ERROR,
              hint = vim.diagnostic.severity.HINT,
              info = vim.diagnostic.severity.INFO,
              warning = vim.diagnostic.severity.WARN,
            },
            { ["source"] = "swift-format" }
          ),
          stream = "both",
          ignore_exitcode = true,
        }
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.fn.executable("sourcekit-lsp") ~= 1 then
        return
      end

      opts.servers.sourcekit = {
        filetypes = { "swift", "objc", "objcpp" },
      }
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
    keys = {
      {
        "<leader><F5>",
        function()
          vim.g.swift_dap_executable = nil
          vim.g.swift_dap_argv = nil

          require("dap").continue()
        end,
        desc = "Debug Start/Continue",
        ft = "swift",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "mmllr/neotest-swift-testing" },
    },
    opts = {
      adapters = {
        ["neotest-swift-testing"] = {},
      },
    },
  },
}

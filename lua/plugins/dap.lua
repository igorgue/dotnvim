return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    local home = os.getenv("HOME") or ""

    dapui.setup({
      floating = {
        border = "rounded",
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end

    require("dap-python").setup(home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

    dap.adapters.elixir = {
      type = "executable",
      command = home .. "/.local/share/nvim/mason/packages/elixir-ls/debugger.sh",
    }

    dap.configurations.elixir = {
      {
        type = "elixir",
        name = "Run Elixir Program",
        task = "phx.server",
        taskArgs = { "--trace" },
        request = "launch",
        startApps = true, -- for Phoenix projects
        projectDir = "${workspaceFolder}",
        requireFiles = {
          "test/**/test_helper.exs",
          "test/**/*_test.exs",
        },
      },
    }

    -- dart
    dap.adapters.dart = {
      type = "executable",
      command = "flutter",
      args = { "debug-adapter" },
    }

    dap.configurations.dart = {}
    require("dap.ext.vscode").load_launchjs()

    -- rust
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = home .. "/.local/share/nvim/mason/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
  keys = {
    { "<F5>", "<Cmd>lua require('dap').continue()<CR>", desc = "Debug continue" },
    { "<F6>", "<Cmd>lua require('dap').step_over()<CR>", desc = "Debug step over" },
    { "<F7>", "<Cmd>lua require('dap').step_into()<CR>", desc = "Debug step into" },
    { "<F8>", "<Cmd>lua require('dap').step_out()<CR>", desc = "Debug step out" },
    { "<leader>b", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Debug toggle breakpoint" },
    {
      "<leader>B",
      "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Debug breakpoint condition",
    },
    {
      "<leader>L",
      "<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      desc = "Debug log point message",
    },
    { "<m-r>", "<Cmd>lua require('dap').repl.open()<CR>", desc = "Debug repl open" },
    { "<m-l>", "<Cmd>lua require('dap').run_last()<CR>", desc = "Debug run last" },
  },
}

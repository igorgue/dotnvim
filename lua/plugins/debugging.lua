return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    {
      "jbyuki/one-small-step-for-vimkind",
      -- stylua: ignore
      keys = {
        { "<leader>daL", function() require("osv").launch({ port = 8086 }) end, desc = "Adapter Lua Server" },
        { "<leader>dal", function() require("osv").run_this() end, desc = "Adapter Lua" },
      },
      config = function() end,
    },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    local mason = (os.getenv("HOME") or "") .. "/.local/share/nvim/mason"

    dapui.setup({
      floating = {
        border = "single",
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

    require("dap-python").setup(mason .. "/packages/debugpy/venv/bin/python")

    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    dap.adapters.elixir = {
      type = "executable",
      command = mason .. "/packages/elixir-ls/debugger.sh",
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
        command = mason .. "/bin/codelldb",
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input({ prompt = "Path to executable: ", default = vim.fn.getcwd() .. "/", completion = "file" })
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
  keys = {
    { "<F5>", "<Cmd>lua require('dap').continue()<CR>", desc = "Debug Start/Continue" },
    { "<F6>", "<Cmd>lua require('dap').step_over()<CR>", desc = "Debug Step Over" },
    { "<F7>", "<Cmd>lua require('dap').step_into()<CR>", desc = "Debug Step Into" },
    { "<F8>", "<Cmd>lua require('dap').step_out()<CR>", desc = "Debug Step Out" },
    { "<F9>", "<Cmd>DapTerminate<CR>", desc = "Debug Terminate DAP" },
    { "<leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
    {
      "<leader>dB",
      "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Breakpoint Condition",
    },
    {
      "<leader>dl",
      "<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      desc = "Log Point Message",
    },
    { "<m-r>", "<Cmd>lua require('dap').repl.open()<CR>", desc = "Debug Repl Open" },
    { "<m-l>", "<Cmd>lua require('dap').run_last()<CR>", desc = "Debug Run Last" },
  },
}

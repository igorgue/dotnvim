return {
  "mfussenegger/nvim-dap",
  opts = {
    floating = {
      border = "single",
    },
  },
  keys = {
    { "<F5>", "<Cmd>lua require('dap').continue()<CR>", desc = "Debug Start/Continue" },
    { "<F6>", "<Cmd>lua require('dap').step_over()<CR>", desc = "Debug Step Over" },
    { "<F7>", "<Cmd>lua require('dap').step_into()<CR>", desc = "Debug Step Into" },
    { "<F8>", "<Cmd>lua require('dap').step_out()<CR>", desc = "Debug Step Out" },
    { "<F9>", "<Cmd>DapTerminate<CR>", desc = "Debug Terminate DAP" },
    { "<m-r>", "<Cmd>lua require('dap').repl.open()<CR>", desc = "Debug Repl Open" },
    { "<m-l>", "<Cmd>lua require('dap').run_last()<CR>", desc = "Debug Run Last" },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Breakpoint Condition",
    },
  },
}

return {
  "greggh/claude-code.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  cmd = "ClaudeCode",
  keys = {
    { "<leader>al", "<cmd>ClaudeCode<cr>", desc = "Toggle ClaudeCode" },
  },
}

return {
  "joshuavial/aider.nvim",
  desc = "Aider AI coding assistant",
  opts = {
    auto_manage_context = true,
    default_bindings = false,
    debug = false,
  },
  cmd = { "AiderOpen", "AiderAddModifiedFiles" },
  keys = {
    { "<leader>ai", "<cmd>AiderOpen<cr>", desc = "Aider open" },
    { "<leader>aI", "<cmd>AiderOpen<cr>", desc = "Aider open with modified files" },
  },
}

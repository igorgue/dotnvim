return {
  desc = "My own config for sidekick",
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
        tools = {
          ccr = { cmd = { "ccr", "code" }, url = "https://github.com/musistudio/claude-code-router" },
        },
      },
    },
  },
}

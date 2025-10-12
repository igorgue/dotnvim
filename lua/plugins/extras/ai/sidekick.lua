return {
  desc = "My own config for sidekick",
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        tools = {
          claude = {
            cmd = { "claude", "--dangerously-skip-permissions", "-c" },
            url = "https://github.com/anthropics/claude-code",
          },
          ccr = {
            cmd = { "ccr", "code", "--dangerously-skip-permissions", "-c" },
            url = "https://github.com/musistudio/claude-code-router",
          },
        },
      },
    },
  },
}

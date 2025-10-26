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
          amp = {
            cmd = { "amp", "thread", "continue" },
            url = "https://ampcode.com",
          },
          claude = {
            cmd = { "claude", "--dangerously-skip-permissions", "-c" },
            url = "https://github.com/anthropics/claude-code",
          },
          ccr = {
            cmd = { "ccr", "code", "--dangerously-skip-permissions", "-c" },
            url = "https://github.com/musistudio/claude-code-router",
          },
          copilot = {
            cmd = { "copilot", "--allow-all-tools" },
            url = "https://github.com/github/copilot-cli",
          },
        },
      },
    },
  },
}

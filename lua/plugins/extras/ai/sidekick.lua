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
            is_proc = "\\<amp\\>",
          },
          claude = {
            cmd = { "claude", "--dangerously-skip-permissions" },
            url = "https://github.com/anthropics/claude-code",
          },
          ccr = {
            cmd = { "ccr", "code", "--dangerously-skip-permissions" },
            url = "https://github.com/musistudio/claude-code-router",
            is_proc = "\\<ccr\\>",
          },
          copilot = {
            cmd = { "copilot", "--allow-all-tools" },
            url = "https://github.com/github/copilot-cli",
            is_proc = "\\<copilot\\>",
          },
          goose = {
            cmd = { "goose" },
            url = "https://github.com/block/goose",
            is_proc = "\\<goose\\>",
          },
        },
      },
    },
  },
}

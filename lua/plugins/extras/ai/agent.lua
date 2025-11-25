return {
  {
    "igorgue/agent.nvim",
    dir = "~/Code/agent.nvim",
    build = ":UpdateRemotePlugins",
    lazy = false,
    keys = {
      {
        "<C-c>",
        "<cmd>AgentCancel<cr>",
        ft = { "agent-prompt", "agent-content" },
        desc = "Cancel agent request",
      },
    },
  },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = {
  --     file_types = { "markdown", "codecompanion", "agent-prompt" },
  --     preset = "lazy",
  --     code = {
  --       disable_background = true,
  --     },
  --     restart_highlighter = false,
  --     completions = {
  --       blink = { enabled = true },
  --       lsp = { enabled = true },
  --     },
  --     heading = {
  --       icons = false,
  --     },
  --   },
  --   ft = { "markdown", "codecompanion", "agent-prompt" },
  -- },
}

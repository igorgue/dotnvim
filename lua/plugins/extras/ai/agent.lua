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
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "igorgue/agent.nvim",
        dir = "~/Code/agent.nvim",
      },
    },
    opts = {
      completion = {
        accept = {
          auto_brackets = {
            kind_resolution = {
              blocked_filetypes = { "agent-prompt", "agent-content" },
            },
            semantic_token_resolution = {
              blocked_filetypes = { "agent-prompt", "agent-content" },
            },
          },
        },
      },
      sources = {
        default = { "agent_files", "agent_commands" },
        providers = {
          -- agent.nvim file completions (@ mentions)
          agent_files = {
            name = "Agent Files",
            module = "agent_nvim.blink.files",
            enabled = function()
              return vim.bo.filetype == "agent-prompt"
            end,
          },

          -- agent.nvim command completions (/ commands)
          agent_commands = {
            name = "Agent Commands",
            module = "agent_nvim.blink.commands",
            enabled = function()
              return vim.bo.filetype == "agent-prompt"
            end,
          },
        },
      },
    },
  },
}

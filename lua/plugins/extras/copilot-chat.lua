return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = false,
      mappings = {
        submit_prompt = {
          insert = "<C-CR>",
        },
      },
    },
    build = "make tiktoken",
    keys = {
      { "<C-;>", "<cmd>CopilotChatToggle<cr>", desc = "Toggle (CopilotChat)", mode = { "n", "v", "i" } },
    },
  },
}

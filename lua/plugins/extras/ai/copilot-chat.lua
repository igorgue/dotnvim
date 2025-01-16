return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = false,
      chat_autocomplete = false,
      -- model = "o1",
      mappings = {
        submit_prompt = {
          insert = "<C-CR>",
        },
        complete = {
          insert = "<s-Tab>",
        },
        reset = {
          insert = "<C-r>",
          normal = "<C-r>",
        },
      },
    },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatToggle",
      "CopilotChatLoad",
      "CopilotChatSave",
      "CopilotChatReset",
    },
    keys = {
      {
        "<C-;>",
        "<cmd>CopilotChatToggle<cr>",
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v", "i" },
      },
      {
        "<C-s-;>",
        function()
          vim.cmd([[
            CopilotChatLoad default
            CopilotChatToggle
          ]])
        end,
        desc = "Reload (CopilotChat)",
        mode = { "n", "v", "i" },
      },
      {
        "<C-s>",
        "<cmd>CopilotChatSave default<cr>",
        desc = "Save (CopilotChat)",
        mode = { "n", "v", "i" },
        ft = "copilot-chat",
      },
      {
        "<Tab>",
        'copilot#Accept("\\<CR>")',
        desc = "Completion (Copilot)",
        mode = "i",
        expr = true,
        replace_keycodes = false,
        ft = "copilot-chat",
      },
    },
  },
}

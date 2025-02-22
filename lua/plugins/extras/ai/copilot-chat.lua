return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = false,
      chat_autocomplete = true,
      log_level = "error",
      -- model = "DeepSeek-R1",
      model = "o3-mini",
      mappings = {
        submit_prompt = {
          insert = "<C-CR>",
        },
        complete = {
          insert = "<s-Tab>",
        },
        reset = {
          insert = "<C-del>",
          normal = "<C-del>",
        },
      },
    },
    build = "make tiktoken",
    cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatLoad", "CopilotChatSave", "CopilotChatReset" },
    init = function()
      LazyVim.on_very_lazy(function()
        vim.cmd("CopilotChatLoad default")
      end)

      vim.api.nvim_create_autocmd("BufWinLeave", {
        pattern = "copilot-chat",
        callback = function()
          vim.cmd("CopilotChatSave default")
        end,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          vim.cmd("CopilotChatSave default")
        end,
      })
    end,
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
        silent = true,
        replace_keycodes = false,
        ft = "copilot-chat",
      },
    },
  },
}

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- still accessible via ctrl+; and the rest of the keys actually work
    -- this is the only way to make `<leader>aa` work for avante
    -- stylua: ignore
    keys = function() return {} end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "gemini",
      -- provider = "openai",
      -- provider = "deepseek",
      gemini = {
        model = "gemini-2.5-pro-exp-03-25",
        max_tokens = 1000000,
        timeout = 60000,
      },
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
      openai = {
        timeout = 60000,
      },
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-reasoner",
          disable_tools = true,
          temperature = 0,
          timeout = 60000,
          max_tokens = 8192,
          stream = true,
        },
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          disable_tools = true,
          timeout = 60000,
          endpoint = "http://127.0.0.1:11434/v1",
          -- model = "deepseek-r1:8b",
          -- model = "deepseek-coder:6.7b",
          model = "deepseek-coder-v2:16b",
        },
      },
      mappings = {
        --- @class AvanteConflictMappings
        submit = {
          normal = "<CR>",
          insert = "<S-CR>",
        },
        sidebar = {
          close = "q",
        },
      },
      hints = { enabled = false },
    },
    keys = {
      -- { "<C-;>", "<cmd>AvanteToggle<cr>", desc = "Toggle (Avante)", mode = { "n", "v", "i" } },
      {
        "<C-del>",
        "<cmd>AvanteClear<cr>",
        desc = "Clear (Avante)",
        mode = { "n", "v", "i" },
        ft = { "AvanteInput", "AvanteSelectedFiles", "Avante" },
      },
    },
  },
}

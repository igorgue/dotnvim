vim.g.lazyvim_ai_assistant = vim.env.LAZYVIM_AI_ASSISTANT or "avante"

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
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "ravitemer/mcphub.nvim",
        opts = {
          extensions = {
            avante = {
              make_slash_commands = true,
            },
          },
        },
      },
    },
    opts = {
      system_prompt = function()
        local prompt = require("plugins.ai.system-prompt")({ name = "Avante" })
        local hub = require("mcphub").get_hub_instance()

        return prompt .. "\n\nMCP Hub:\n\n" .. hub:get_active_servers_prompt()
      end,
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      cursor_provider = "copilot",
      memory_summary_provider = "copilot",
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      gemini = {
        model = "gemini-2.5-pro-exp-03-25",
        max_tokens = 1000000,
        timeout = 60000,
      },
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4.1",
        max_tokens = 1000000,
        timeout = 60000,
      },
      selector = {
        provider = "snacks",
        provider_opts = {
          ignore_gitignore = false, -- Hypothetical option to disable respecting .gitignore
        },
      },
      openai = {
        timeout = 60000,
      },
      windows = {
        width = 40,
        edit = {
          start_insert = false,
        },
        ask = {
          floating = true,
          start_insert = false,
        },
        sidebar_header = {
          align = "left",
          rounded = false,
        },
      },
      rag_service = {
        enabled = false,
      },
      dual_boost = {
        enabled = true,
        first_provider = "gemini",
        second_provider = "openai",
      },
      behaviour = {
        auto_focus_sidebar = true,
        auto_suggestions = false, -- Experimental stage
        auto_suggestions_respect_ignore = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        jump_result_buffer_on_finish = true,
        support_paste_from_clipboard = true,
        minimize_diff = true,
        enable_token_counting = false,
        use_cwd_as_project_root = true,
        auto_focus_on_diff_view = true,
      },
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-chat",
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
          close_from_input = { normal = "q", insert = "<C-d>" },
        },
      },
      hints = { enabled = true },
    },
    keys = function()
      local k = {
        {
          "<C-del>",
          "<cmd>AvanteClear<cr>",
          desc = "Clear (Avante)",
          mode = { "n", "v", "i" },
          ft = { "AvanteInput", "AvanteSelectedFiles", "Avante" },
        },
        {
          "<c-y>",
          function()
            vim.api.nvim_input("iYes<esc><cr>")
          end,
          desc = "Yes Yes Yes (Avante)",
          mode = { "n" },
          ft = { "AvanteInput" },
        },
      }

      if vim.g.lazyvim_ai_assistant == "avante" then
        table.insert(k, { "<C-;>", "<cmd>AvanteToggle<cr>", desc = "Toggle (Avante)", mode = { "n", "v", "i" } })
      end

      return k
    end,
  },
}

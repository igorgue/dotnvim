return {
  {
    "Davidyz/VectorCode",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "j-hui/fidget.nvim" },
    config = true,
    cmd = "CodeCompanion",
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          roles = {
            user = "igorgue",
          },
          keymaps = {
            send = {
              modes = {
                i = "<CR>",
                n = "<CR>",
              },
            },
          },
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "snacks",
                keymaps = {
                  modes = {
                    i = "<C-b>",
                  },
                },
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks",
                max_lines = 1000,
              },
            },
            ["file"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
          },
          tools = {
            vectorcode = {
              description = "Run VectorCode to retrieve the project context.",
              callback = function()
                return require("vectorcode.integrations").codecompanion.chat.make_tool()
              end,
            },
          },
        },
        inline = { adapter = "copilot" },
      },
      display = {
        action_palette = { provider = "default" },
        chat = {
          show_references = true,
          show_header_separator = true,
          show_settings = false,
        },
      },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    keys = {
      { "<C-;>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle (CopilotChatToggle)", mode = { "n", "v", "i" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion Chat", mode = { "n", "v" } },
    },
  },
}

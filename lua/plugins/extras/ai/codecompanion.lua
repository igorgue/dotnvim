return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
      { "Davidyz/VectorCode", cmd = "VectorCode" },
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-pro-exp-03-25",
              },
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "o3-mini-2025-01-31",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "openai",
          -- adapter = "gemini",
          -- adapter = "deepseek",
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
        inline = { adapter = "openai" },
      },
      display = {
        -- action_palette = { provider = "default" },
        action_palette = {
          provider = "default",
          opts = {
            show_default_actions = false,
            show_default_prompt_library = false,
          },
        },
        chat = {
          show_references = true,
          show_header_separator = true,
          show_settings = false,
          render_headers = false,
        },
        -- diff = {
        --   provider = "mini_diff",
        -- },
      },
      prompt_library = {
        ["Write Commit Message"] = {
          strategy = "inline",
          description = "Generates a commit message on git commit file",
          -- opts = {
          --   adapter = {
          --     name = "openai",
          --   },
          -- },
          prompts = {
            {
              role = "system",
              content = "You're an assistant dedicated to write commit messages based on the current buffer",
            },
            {
              role = "user",
              content = "#buffer @editor write the commit message for me",
            },
          },
        },
      },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])
      vim.cmd([[cab cca CodeCompanionActions]])
    end,
    config = function(_, opts)
      local progress = require("fidget.progress")
      local handles = {}

      local function store_progress_handle(id, handle)
        handles[id] = handle
      end

      local function pop_progress_handle(id)
        local handle = handles[id]
        handles[id] = nil

        return handle
      end

      local function llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
          table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
      end

      local function create_progress_handle(request)
        return progress.handle.create({
          title = "",
          message = "  " .. request.data.strategy,
          lsp_client = {
            name = llm_role_title(request.data.adapter),
          },
        })
      end

      local function report_exit_status(handle, request)
        if request.data.status == "success" then
          handle.message = "Completed"
        elseif request.data.status == "error" then
          handle.message = " Error"
        else
          handle.message = "󰜺 Cancelled"
        end
      end

      local function init_spinner()
        local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = "CodeCompanionRequestStarted",
          group = group,
          callback = function(request)
            local handle = create_progress_handle(request)
            store_progress_handle(request.data.id, handle)
          end,
        })

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = "CodeCompanionRequestFinished",
          group = group,
          callback = function(request)
            local handle = pop_progress_handle(request.data.id)
            if handle then
              report_exit_status(handle, request)
              handle:finish()
            end
          end,
        })
      end

      init_spinner()

      require("codecompanion").setup(opts)
    end,
    keys = {
      { "<C-;>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle (CopilotChatToggle)", mode = { "n", "v", "i" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion Chat", mode = { "n", "v" } },
    },
  },
}

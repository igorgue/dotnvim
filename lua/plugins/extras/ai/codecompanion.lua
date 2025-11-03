vim.g.codecompanion_auto_tool_mode = true
vim.g.codecompanion_yolo_mode = true
vim.g.codecompanion_prompt_decorator = true
vim.g.codecompanion_attached_prompt_decorator = false

vim.g.mcphub_auto_approve = true

local programmer_tools = {
  "read_file",
  "cmd_runner",
  "neovim__read_multiple_files",
  "neovim__write_file",
  "neovim__edit_file",
}

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionChatCleared",
  group = group,
  callback = function(request)
    vim.g.codecompanion_attached_prompt_decorator = false
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",

    -- Main plugin configuration
    -- Defines dependencies, commands, initialization, and setup options
    dependencies = {
      {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
          linters_by_ft = {
            codecompanion = {},
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            marksman = {
              autostart = function(bufnr)
                return vim.bo[bufnr].filetype ~= "codecompanion"
              end,
            },
          },
        },
      },
      "j-hui/fidget.nvim",
      "ravitemer/codecompanion-history.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        opts = {
          verbose = false,
          drag_and_drop = {
            enabled = false,
          },
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
      { "nvim-lua/plenary.nvim", branch = "master" },
      {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "VectorCode",
      },
      "e2r2fx/codecompanion-fast-apply.nvim",
      {
        "ravitemer/mcphub.nvim",
        cmd = "MCPHub",
        build = "bundled_build.lua",
        opts = {
          config = vim.fn.expand("~/.config/mcphub/servers.json"),
          auto_approve = true,
          auto_toggle_mcp_servers = true,
          use_bundled_binary = false,
          extensions = {
            codecompanion = {
              show_result_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
            },
          },
          log = {
            level = vim.log.levels.INFO,
            to_file = false,
            file_path = nil,
            prefix = "MCPHub",
          },
          ui = {
            window = {
              border = "none",
            },
          },
        },
        keys = {
          { "<leader>am", "<cmd>MCPHub<cr>", desc = "Open MCPHub" },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "codecompanion" },
          code = {
            disable_background = true,
          },
        },
        ft = { "markdown", "codecompanion" },
      },
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
      vim.cmd([[cab ccc CodeCompanionChat]])
      vim.cmd([[cab cca CodeCompanionActions]])
    end,
    config = function(_, opts)
      require("codecompanion").setup(opts)
      require("plugins.codecompanion.fidget-spinner"):init()
    end,
    opts = {
      -- Global `opts`
      opts = {
        system_prompt = require("plugins.ai.system-prompt"),
        language = "English",
        send_code = true,
        folds = {
          enable = true,
        },
      },
      adapters = {
        acp = {
          codex = {
            name = "codex",
            formatted_name = "Codex",
            type = "acp",
            roles = {
              llm = "assistant",
              user = "user",
            },
            defaults = {},
            opts = {
              vision = true,
            },
            commands = {
              default = {
                "codex-acp",
              },
            },
            env = {
              OPENAI_API_KEY = "OPENAI_API_KEY",
              RUST_LOG = "error",
            },
            parameters = {
              protocolVersion = 1,
              clientCapabilities = {
                fs = { readTextFile = true, writeTextFile = true },
              },
              clientInfo = {
                name = "CodeCompanion.nvim",
                version = "1.0.0",
              },
            },
            handlers = {
              ---@param self CodeCompanion.ACPAdapter
              ---@return boolean
              setup = function(self)
                return true
              end,

              ---@param self CodeCompanion.ACPAdapter
              ---@return boolean
              auth = function(self)
                local token = self.env_replaced.OPENAI_API_KEY
                if token and token ~= "" then
                  vim.env.OPENAI_API_KEY = token
                  return true
                end
                return false
              end,

              ---@param self CodeCompanion.ACPAdapter
              ---@param messages table
              ---@param capabilities table
              ---@return table
              form_messages = function(self, messages, capabilities)
                return require("codecompanion.adapters.acp.helpers").form_messages(self, messages, capabilities)
              end,

              ---Function to run when the request has completed. Useful to catch errors
              ---@param self CodeCompanion.ACPAdapter
              ---@param code number
              ---@return nil
              on_exit = function(self, code) end,
            },
          },
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              -- env = {
              --   ANTHROPIC_BASE_URL = "http://127.0.0.1:3456",
              --   DISABLE_TELEMETRY = "1",
              --   DISABLE_AUTOUPDATER = "1",
              -- },
            })
          end,
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "gemini-api-key",
                timeout = 60000,
              },
            })
          end,
        },
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4.5",
                  choices = {
                    ["claude-sonnet-4.5"] = { opts = { can_stream = true, can_use_tools = true, has_vision = true } },
                  },
                },
              },
            })
          end,
          copilot_inline = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "gpt-4.1",
                  choices = {
                    ["gpt-4.1"] = { opts = { can_stream = true, can_use_tools = true, has_vision = true } },
                  },
                },
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-pro-preview-05-06",
                  choices = {
                    ["gemini-2.5-pro-preview-05-06"] = {},
                  },
                },
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters").extend("deepseek", {
              schema = {
                model = {
                  default = "deepseek-chat",
                  choices = {
                    ["deepseek-chat"] = {},
                    ["deepseek-coder"] = {},
                  },
                },
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              schema = {
                model = {
                  default = "gpt-5",
                  choices = {
                    ["gpt-5"] = {},
                    ["gpt-4o"] = {},
                    ["gpt-4o-mini"] = {},
                  },
                },
              },
            })
          end,
          moonshot = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "moonshot",
              formatted_name = "MoonshotAI",
              opts = {
                vision = true,
              },
              env = {
                url = "https://api.moonshot.ai",
                api_key = "MOONSHOTAI_API_KEY",
              },
              schema = {
                model = {
                  -- default = "kimi-k2-0905-preview",
                  default = "kimi-k2-turbo-preview",
                  choices = {
                    ["kimi-k2-turbo-preview"] = {},
                    ["kimi-k2-0905-preview"] = {},
                  },
                },
                temperature = {
                  default = 0.3,
                  -- default = 0.6, -- for 0905
                },
                max_tokens = {
                  default = -1,
                },
              },
            })
          end,
          dashscope = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "dashscope",
              formatted_name = "DashScope (Alibaba Cloud)",
              env = {
                url = "https://dashscope-intl.aliyuncs.com/compatible-mode",
                api_key = "DASHSCOPE_API_KEY",
              },
              schema = {
                model = {
                  -- default = "qwen3-coder-plus",
                  default = "qwen3-max-preview",
                  choices = {
                    ["qwen3-max-preview"] = {},
                    ["qwen3-coder-plus"] = {},
                  },
                },
              },
            })
          end,
          minimax = function()
            return require("codecompanion.adapters").extend("anthropic", {
              name = "minimax",
              formatted_name = "Minimax",
              url = "https://api.minimax.io/anthropic/v1/messages",
              env = {
                api_key = "MINIMAX_API_KEY",
              },
              features = {
                tokens = true,
              },
              schema = {
                model = {
                  default = "minimax-m2",
                  choices = {
                    ["minimax-m2"] = {},
                  },
                },
              },
            })
          end,
        zai = function()
          return require("codecompanion.adapters").extend("anthropic", {
            name = "zai",
            formatted_name = "Z.AI",
            url = "https://api.z.ai/api/anthropic/v1/messages",
            env = {
              api_key = "ZAI_API_KEY",
            },
            features = {
              tokens = true, -- outputs gibberish as token counts
            },
            schema = {
              model = {
                default = "glm-4.6",
                choices = {
                  ["glm-4.6"] = { opts = { can_reason = true, has_vision = true } },
                  ["glm-4.5"] = { opts = { can_reason = true, has_vision = true } },
                  ["glm-4.5-air"] = { opts = { can_reason = false, has_vision = true } },
                },
              },
              max_tokens = {
                default = 200000,
                validate = function(n)
                  return n > 0 and n <= 200000, "Must be between 0 and 200000"
                end,
              },
              -- thinking_budget = {
              --   default = 32000,
              -- },
              tools = {
                output_response = function(_self, tool_call, output)
                  return {
                    role = "tool",
                    content = {
                      type = "tool_result",
                      tool_use_id = tool_call.id,
                      content = output,
                      is_error = false,
                    },
                    opts = { visible = false },
                  }
                end,
              },
            },
          })
        end,
        zai_inline = function()
          return require("codecompanion.adapters").extend("anthropic", {
            name = "zai_inline",
            formatted_name = "Z.AI (inline)",
            url = "https://api.z.ai/api/anthropic/v1/messages",
            env = {
              api_key = "ZAI_API_KEY",
            },
            features = {
              tokens = false, -- outputs gibberish as token counts
            },
            schema = {
              model = {
                default = "glm-4.5-air",
                choices = {
                  ["glm-4.5-air"] = {
                    opts = { can_reason = false, has_vision = false, has_token_efficient_tools = false },
                  },
                },
              },
              temperature = {
                default = 0,
              },
              max_tokens = {
                default = 10000,
                validate = function(n)
                  return n > 0 and n <= 10000, "Must be between 0 and 10000"
                end,
              },
              extended_thinking = {
                default = false,
              },
              thinking_budget = {
                default = 0,
              },
              tools = {
                output_response = function(_self, tool_call, output)
                  return {
                    role = "tool",
                    content = {
                      type = "tool_result",
                      tool_use_id = tool_call.id,
                      content = output,
                      is_error = false,
                    },
                    opts = { visible = false },
                  }
                end,
              },
            },
          })
        end,
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "openrouter",
              formatted_name = "OpenRouter",
              roles = {
                llm = "assistant",
                user = "user",
                tool = "tool",
              },
              opts = {
                stream = true,
                tools = true,
                vision = true,
              },
              features = {
                text = true,
                tokens = true,
              },
              env = {
                api_key = "OPENROUTER_API_KEY",
                url = "https://openrouter.ai/api",
                chat_url = "/v1/chat/completions",
                models_endpoint = "/v1/models",
              },
              schema = {
                model = {
                  default = "z-ai/glm-4.5-air:free",
                  choices = {
                    ["moonshotai/kimi-k2:free"] = {},
                    ["nvidia/nemotron-nano-9b-v2"] = {},
                    ["openai/gpt-5"] = {},
                    ["openai/gpt-5-chat"] = {},
                    ["openai/gpt-5-mini"] = {},
                    ["openai/gpt-5-nano"] = {},
                    ["openai/gpt-oss-120b"] = {},
                    ["openai/gpt-oss-20b"] = {},
                    ["openai/gpt-oss-20b:free"] = {},
                    ["deepseek/deepseek-chat-v3.1"] = {},
                    ["x-ai/grok-code-fast-1"] = {},
                    ["x-ai/grok-4-fast:free"] = {},
                    ["z-ai/glm-4.5-air:free"] = {},
                    ["z-ai/glm-4.6"] = {},
                    ["anthropic/claude-sonnet-4.5"] = {},
                    ["anthropic/claude-sonnet-4"] = {},
                    ["minimax/minimax-m2"] = {},
                  },
                },
              },
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "ollama",
              formatted_name = "Ollama",
              schema = {
                model = {
                  default = "qwen3:8b",
                  choices = {
                    ["qwen3:8b"] = {},
                    ["gpt-oss:20b"] = {},
                    ["codellama:7b"] = {},
                    ["gemma3:12b"] = {},
                  },
                },
              },
            })
          end,
          xai = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "xai",
              formatted_name = "XAi",
              env = {
                url = "https://api.x.ai",
                api_key = "XAI_API_KEY",
              },
              schema = {
                model = {
                  default = "grok-code-fast-1",
                  choices = {
                    ["grok-code-fast-1"] = {},
                  },
                },
              },
            })
          end,
        },
      strategies = {
        chat = {
          opts = {
            prompt_decorator = function(message, _adapter, _context)
              if not vim.g.codecompanion_prompt_decorator or vim.g.codecompanion_attached_prompt_decorator then
                return string.format([[<prompt>%s</prompt>]], message)
              end

              -- local prelude_tools = {}
              local prelude_tools = {
                "@{programmer}",
              }
              -- local prelude_tools = {
              --   "@{cmd_runner}",
              --   "@{read_file}",
              --   "@{neovim__read_multiple_files}",
              --   "@{neovim__write_file}",
              --   "@{neovim__edit_file}",
              -- }
              local prelude = prelude_tools

              -- check if we have any open buffers that are not codecompanion, to add the buffer var
              local bufs = vim.api.nvim_list_bufs()
              local has_non_codecompanion_buffer = false
              for i = #bufs, 1, -1 do
                local buf = bufs[i]
                if vim.bo[buf].filetype ~= "codecompanion" and vim.api.nvim_buf_is_loaded(buf) then
                  local buf_name = vim.api.nvim_buf_get_name(buf)

                  if buf_name and buf_name ~= "" then
                    has_non_codecompanion_buffer = true
                    break
                  end
                end
              end

              if has_non_codecompanion_buffer then
                table.insert(prelude, "#{mcp:neovim://workspace}")
                table.insert(prelude, "#{mcp:neovim://diagnostics/workspace}")
              end

              if #prelude > 0 then
                vim.g.codecompanion_attached_prompt_decorator = true

                if #prelude_tools then
                  return string.format(
                    "Use the following tools: "
                      .. table.concat(prelude, " ")
                      -- .. "\n"
                      -- .. "Use desktop_commander__edit_block to edit files and desktop_commander__write_file to make new files or append to files, don't forget to initialize desktop commander with desktop_commander__set_config_value as explained in the system prompt."
                      .. "\n\n"
                      .. "<prompt>%s</prompt>",
                    message
                  )
                else
                  return string.format(table.concat(prelude, " ") .. "\n\n" .. "<prompt>%s</prompt>", message)
                end
              else
                return string.format("<prompt>%s</prompt>", message)
              end
            end,
          },
          adapter = vim.g.codecompanion_initial_adapter,
          roles = {
            user = vim.env.USERNAME,
            llm = function(adapter)
              if not adapter then
                return "CodeCompanion"
              end

              if adapter.schema and adapter.schema.model then
                return "CodeCompanion (" .. adapter.formatted_name .. ":" .. adapter.schema.model.default .. ")"
              else
                return "CodeCompanion (" .. adapter.formatted_name .. ")"
              end
            end,
          },
          keymaps = {
            send = {
              modes = { i = "<C-CR>", n = "<CR>" },
            },
            clear = {
              modes = {
                i = { "<C-Del>", "<C-Backspace>" },
                n = { "<C-Del>", "<C-Backspace>" },
              },
            },
            close = {
              modes = { n = {}, i = {} },
            },
            stop = {
              modes = { n = "<C-c>", i = "<C-c>" },
            },
            _acp_allow_always = {
              modes = { n = "0" },
              description = "Allow Always",
            },
            _acp_allow_once = {
              modes = { n = "1" },
              description = "Allow Once",
            },
            _acp_reject_once = {
              modes = { n = "2" },
              description = "Reject Once",
            },
            _acp_reject_always = {
              modes = { n = "3" },
              description = "Reject Always",
            },
          },
          variables = {
            ["buffer"] = {
              opts = {
                default_params = "watch",
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
            groups = {
              ["programmer"] = {
                description = "Programmer Tools",
                tools = programmer_tools,
              },
              ["writer"] = {
                description = "Writer Tools",
                tools = {
                  "dreamtap",
                  "wikipedia",
                },
              },
              ["web"] = {
                description = "Search the Web",
                tools = {
                  "exa",
                  "context7",
                  "deepwiki",
                },
              },
              ["docs"] = {
                description = "Documentation Tools",
                tools = {
                  "context7",
                  "deepwiki",
                  "nixos",
                },
              },
            },
            ["cmd_runner"] = {
              requires_approval = false,
            },
            opts = {
              -- default_tools = programmer_tools,
              requires_approval = false,
              auto_submit_errors = false,
              auto_submit_success = false,
              prompt_decorator = function(message, _adapter, _context)
                return string.format([[<tools>%s</tools>]], message)
              end,
            },
          },
        },
        inline = {
          adapter = vim.g.codecompanion_initial_inline_adapter,
          layout = "vertical",
          keymaps = {
            accept_change = {
              modes = { n = "1" },
              description = "Accept",
            },
            reject_change = {
              modes = { n = "2" },
              description = "Reject",
            },
            always_accept = {
              modes = { n = "0" },
              description = "Always Accept",
            },
          },
        },
      },
      display = {
        action_palette = {
          provider = "default",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
        chat = {
          intro_message = "",
          separtor = "---",
          show_references = true,
          show_header_separator = true,
          show_settings = false,
          show_context = true,
          show_token_count = true,
          render_headers = false,
          start_in_insert_mode = false,
          icons = {
            chat_context = "", -- You can also apply an icon to the fold
          },
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
            border = "none",
            height = 1.0,
            width = 0.5,
            relative = "editor",
            full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
            sticky = false, -- when set to true and `layout` is not `"buffer"`, the chat buffer will remain opened when switching tabs
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          fold_context = true,
        },
        diff = {
          provider = "inline",
        },
      },
      prompt_library = {
        ["Write Commit Message"] = {
          strategy = "inline",
          description = "Writes commit message on gitcommit buffer",
          opts = {
            index = 10,
            is_default = false,
            is_slash_cmd = false,
            short_name = "write_commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[@{editor} #{buffer} You are an expert at following the Conventional Commit specification. Given the git diff listed below, generate a commit message for me inside of the current buffer:

```diff
%s
```

And the previous 10 commits, just in case they're related to the current changes:
```gitcommit
%s
```]],
                  vim.fn.system("git diff --no-ext-diff --staged"),
                  vim.fn.system("git log -n 10")
                )
              end,
              opts = {
                contains_code = false,
              },
            },
          },
        },
        ["Diff Review"] = {
          strategy = "chat",
          description = "Review current diff",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "review_diff",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[You are an expert at programmer. Given the `git diff` listed below, please give me a review of the changes:

```diff
%s
```
And the previous 10 commits, just in case they're related to the current changes:
```gitcommit
%s
```]],
                  vim.fn.system("git diff --no-ext-diff"),
                  vim.fn.system("git log -n 10")
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Enhance Prompt"] = {
          strategy = "inline",
          description = "Enhance prompt",
          opts = {
            index = 10,
            is_default = false,
            is_slash_cmd = false,
            short_name = "enhance",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = "Rewrite the following prompt, improving it to be more effective and efficient to be read by an LLMs:",
            },
          },
        },
      },
      extensions = {
        fast_apply = {
          enabled = true,
          opts = {
            adapter = "openai_compatible",
            model = "auto",
            url = "https://api.morphllm.com",
            api_key = "MORPH_API_KEY",
          },
        },
        vectorcode = {
          opts = {
            add_tool = true, -- Enable VectorCode as a tool in the chat interface
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion", -- Callback function for MCP integration
          opts = {
            auto_approve = true, -- Automatically approve MCP tool calls
            show_result_in_chat = true, -- Display MCP tool results in the chat
            make_vars = true, -- Convert MCP resources to #variables
            make_slash_commands = true, -- Add MCP prompts as /slash commands
            make_tools = true, -- Add MCP prompts as tools
          },
        },
        history = {
          enabled = true, -- Enable chat history functionality
          opts = {
            keymap = "gh", -- Keymap to open history picker
            save_chat_keymap = "sc", -- Keymap to save current chat
            auto_save = true, -- Automatically save chats
            expiration_days = 0, -- Never expire chats (0 = no expiration)
            picker = "snacks", -- Use Snacks picker for history
            auto_generate_title = true, -- Automatically generate chat titles
            title_generation_opts = {
              adapter = "copilot", -- Use Copilot for title generation
              model = "gpt-4.1", -- Specific model for title generation
            },
            continue_last_chat = false, -- Don't auto-continue previous chats
            delete_on_clearing_chat = false, -- Don't delete history when clearing chat
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history", -- History storage location
            enable_logging = false, -- Disable debug logging
            summary = {
              enabled = true,
              create_summary_keymap = "gcs", -- Keymap to create chat summaries
              browse_summaries_keymap = "gbs", -- Keymap to browse summaries
              generation_opts = {
                adapter = "zai_inline", -- Use Copilot for summary generation
                model = "glm-4.5-air", -- Specific model for summaries
                context_size = 128000, -- Maximum context size for summaries
                include_references = false, -- Don't include code references
                include_tool_outputs = false, -- Don't include tool outputs
              },
            },
            memory = {
              enabled = true,
              auto_create_memories_on_summary_generation = true, -- Auto-create memories from summaries
              vectorcode_exe = "vectorcode", -- VectorCode executable for memory indexing
              tool_opts = {
                default_num = 10, -- Default number of memories to retrieve
              },
              notify = true, -- Show notifications for memory operations
              index_on_startup = false, -- Don't index on startup (performance)
            },
          },
        },
      },
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>ae",
        function()
          require("codecompanion").prompt("enhance")
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        mode = "v",
        desc = "Enhance the selected text",
      },
      {
        "<leader>ae",
        function()
          -- Get current cursor position
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          local current_line = cursor_pos[1]

          -- Find the start of the current block (empty line or start of file)
          local start_line = 1
          for i = current_line, 1, -1 do
            local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
            if line:match("^%s*$") then -- Empty line
              start_line = i + 1
              break
            elseif i == 1 then
              start_line = 1
              break
            end
          end

          -- Find the end of the current block (empty line or end of file)
          local total_lines = vim.api.nvim_buf_line_count(0)
          local end_line = total_lines
          for i = current_line, total_lines do
            local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
            if line:match("^%s*$") and i > current_line then -- Empty line after current line
              end_line = i - 1
              break
            elseif i == total_lines then
              end_line = total_lines
              break
            end
          end

          -- Select the block visually
          vim.api.nvim_win_set_cursor(0, { start_line, 0 })
          vim.cmd("normal! V")
          vim.api.nvim_win_set_cursor(0, { end_line, 0 })

          -- Execute the enhance function
          require("codecompanion").prompt("enhance")
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        mode = "n",
        desc = "Enhance the current block",
      },
      {
        "<leader>gc",
        "<cmd>CodeCompanion /write_commit<cr>",
        desc = "Write the git commit for you",
        ft = "gitcommit",
      },
      { "<C-;>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle (CodeCompanionChat)", mode = { "n", "i" } },
      {
        "<C-;>",
        function()
          local found = false
          local bufs = vim.api.nvim_list_bufs()
          for i = #bufs, 1, -1 do
            local buf = bufs[i]
            if vim.bo[buf].filetype == "codecompanion" then
              found = true
            end
          end

          if found then
            vim.cmd("CodeCompanionChat Add")
          else
            vim.cmd("CodeCompanionChat Toggle")
          end
        end,
        desc = "Toggle Adding (CodeCompanionChat Add)",
        mode = "v",
      },
      {
        "<M-;>",
        function()
          if vim.bo.ft == "codecompanion" then
            if Snacks.zen.win and Snacks.zen.win:valid() then
              Snacks.zen.zoom()
            end

            vim.cmd("CodeCompanionChat Toggle")
            return
          end

          vim.cmd("CodeCompanionChat")
          Snacks.zen.zoom()
        end,
        desc = "Open Code Companion Chat Zoomed In",
        mode = { "n", "v", "i" },
      },
      { "<leader>ac", "", desc = "+codecompanion", mode = { "n", "v" } },
      { "<leader>aca", "<cmd>CodeCompanionActions<cr>", desc = "Open actions" },
      { "<leader>acc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
      { "<leader>acn", "<cmd>CodeCompanionChat<cr>", desc = "New CodeCompanion Chat" },
      { "<leader>gc", "<cmd>CodeCompanion /write_commit<cr>", desc = "Write the git commit for you", ft = "gitcommit" },
    },
  },
}

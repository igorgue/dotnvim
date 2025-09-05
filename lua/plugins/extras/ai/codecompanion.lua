vim.g.codecompanion_auto_tool_mode = true
vim.g.mcphub_auto_approve = true
vim.g.codecompanion_yolo_mode = true

local default_tools = {
  "desktop_commander",
  "cmd_runner",
  -- "create_file",
  "read_file",
  "insert_edit_into_file",
  -- "file_search",
  -- "grep_search",
}
-- CodeCompanion Configuration
-- This file configures the CodeCompanion plugin, which provides AI-powered coding assistance
-- directly within Neovim. It integrates with multiple AI providers and offers features like
-- chat interfaces, inline code suggestions, and automated code reviews.

-- Global configuration variables
-- These settings enable automatic tool mode and MCP hub auto-approval

-- Auto command to add username to spell good words
return {
  {
    "olimorris/codecompanion.nvim",

    -- Main plugin configuration
    -- Defines dependencies, commands, initialization, and setup options
    dependencies = {
      "j-hui/fidget.nvim",
      "ravitemer/codecompanion-history.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        opts = {
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
      {
        "ravitemer/mcphub.nvim",
        cmd = "MCPHub",
        build = "bundled_build.lua",
        event = "VeryLazy",
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
      -- Load prompt enhancer commands
      require("plugins.ai.prompt-enhancer-commands")
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
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                ANTHROPIC_MODEL = "kimi-k2-turbo-preview",
                DISABLE_TELEMETRY = "1",
                DISABLE_AUTOUPDATER = "1",
              },
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
                default = "gpt-4.1",
              },
            },
          })
        end,
        copilot_inline = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4.1",
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-pro-preview-05-06",
              },
            },
          })
        end,
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            schema = {
              model = {
                default = "deepseek-chat",
              },
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "gpt-4.1",
              },
            },
          })
        end,
        -- Configuration with OpenAI endpoint
        moonshot = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "moonshot",
            formatted_name = "MoonshotAI",
            opts = {
              vision = false,
            },
            env = {
              url = "https://api.moonshot.ai",
              api_key = "MOONSHOTAI_API_KEY",
            },
            schema = {
              model = {
                -- default = "kimi-k2-0905-preview",
                default = "kimi-k2-turbo-preview",
              },
              -- temperature = {
              --   default = 0.2,
              -- },
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
                default = "qwen3-coder-plus",
              },
            },
          })
        end,
        openrouter_inline = function()
          local openrouter = require("plugins.ai.openrouter")

          return require("codecompanion.adapters").extend(openrouter, {
            name = "openrouter-inline",
            formatted_name = "OpenRouter (inline, free default)",
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
            },
            schema = {
              model = {
                default = "openai/gpt-oss-120b:free",
                -- default = "qwen/qwen3-coder:free",
                choices = {
                  ["openai/gpt-oss-120b:free"] = {},
                  ["openai/gpt-oss-20b:free"] = {},
                  ["qwen/qwen3-coder:free"] = {},
                },
              },
            },
          })
        end,
        openrouter = function()
          local openrouter = require("plugins.ai.openrouter")

          return require("codecompanion.adapters").extend(openrouter, {
            name = "openrouter",
            formatted_name = "OpenRouter",
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
            },
            schema = {
              model = {
                default = "openai/gpt-oss-120b",
                choices = {
                  ["openai/gpt-5"] = {},
                  ["openai/gpt-5-chat"] = {},
                  ["openai/gpt-5-mini"] = {},
                  ["openai/gpt-5-nano"] = {},
                  ["openai/gpt-oss-120b"] = {},
                  ["openai/gpt-oss-20b"] = {},
                  ["openai/gpt-oss-20b:free"] = {},
                  ["deepseek/deepseek-chat-v3.1"] = {},
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
                -- default = "qwen3-coder",
                -- default = "gpt-oss:20b",
                default = "codellama:7b",
                -- default = "gemma3:12b",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          opts = {
            -- Prompt enhancement configuration
            prompt_enhancement = {
              enabled = vim.g.codecompanion_prompt_enhancement or false, -- Use env var or default to false
              model = "gemma3:12b", -- Model to use for enhancement (using gemma3:12b for better quality)
              timeout = 30000, -- Timeout in milliseconds (increased for larger model)
              debug = false, -- Debug logging disabled by default (use :CCPromptEnhanceDebug to toggle)
              -- Custom enhancement prompt (optional)
              -- enhancement_prompt = "Your custom enhancement instructions here"
            },
            prompt_decorator = function(message, adapter, context)
              -- -- Get the current configuration dynamically
              -- local config = require("codecompanion.config")
              -- local runtime_config = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement") or {}
              --
              -- -- Merge with defaults
              -- local enhancement_config = vim.tbl_extend("force", {
              --   enabled = true,
              --   model = "gemma3:12b",
              --   timeout = 30000,
              --   debug = false,
              -- }, runtime_config)
              --
              -- -- Check if enhancement is enabled (can be toggled at runtime)
              -- if not enhancement_config.enabled then
              --   return string.format([[<prompt>%s</prompt>]], message)
              -- end
              --
              -- -- Log what we're about to enhance
              -- if enhancement_config.debug then
              --   vim.notify(string.format("Enhancing prompt: %s", message), vim.log.levels.INFO)
              -- end
              --
              -- -- Enhance the prompt synchronously (for simplicity)
              -- local enhanced_message = enhancer.enhance_prompt(message, enhancement_config)
              --
              -- -- Log the result
              -- if enhancement_config.debug and enhanced_message ~= message then
              --   vim.notify(string.format("Enhanced to: %s", enhanced_message), vim.log.levels.INFO)
              -- end

              -- Wrap in prompt tags
              return string.format([[<prompt>%s</prompt>]], message)
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
                -- i = "<C-del>",
                -- n = "<C-del>",
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
            ["cmd_runner"] = {
              requires_approval = false,
            },
            opts = {
              default_tools = default_tools,
              requires_approval = false,
              auto_submit_errors = false,
              auto_submit_success = false,
              prompt_decorator = function(message, _adapter, _context)
                return string.format([[<prompt>%s</prompt>]], message)
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
              spell = true,
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
        ["Improve Prompt"] = {
          strategy = "inline",
          description = "Improve prompt",
          opts = {
            index = 10,
            is_default = false,
            is_slash_cmd = false,
            short_name = "improve_prompt",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = "Improve the following prompt to be more effective and efficient with LLMs",
            },
          },
        },
      },
      extensions = {
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            auto_approve = true, -- Auto approve mcp tool calls
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            auto_generate_title = true,
            title_generation_opts = {
              adapter = "copilot",
              model = "gpt-4.1",
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            enable_logging = false,
            summary = {
              create_summary_keymap = "gcs",
              browse_summaries_keymap = "gbs",
              generation_opts = {
                adapter = "copilot",
                model = "gpt-4.1",
                context_size = 128000,
                include_references = false,
                include_tool_outputs = false,
              },
            },
            memory = {
              auto_create_memories_on_summary_generation = true,
              vectorcode_exe = "vectorcode",
              tool_opts = {
                default_num = 10,
              },
              notify = true,
              index_on_startup = false,
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("codecompanion").prompt("improve_prompt")
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        mode = "v",
        desc = "Improve the selected prompt",
        ft = "codecompanion",
      },
      {
        "<leader><leader>",
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

          -- Execute the improve_prompt function
          require("codecompanion").prompt("improve_prompt")
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
        mode = "n",
        desc = "Improve the current block of text",
        ft = "codecompanion",
      },
      {
        "<leader>gc",
        "<cmd>CodeCompanion /write_commit<cr>",
        desc = "Write the git commit for you",
        ft = "gitcommit",
      },
      {
        "<C-del>",
        function()
          -- Get the current chat instance
          local Chat = require("codecompanion.strategies.chat")
          local chat = Chat.buf_get_chat(vim.api.nvim_get_current_buf())

          if not chat then
            return
          end

          -- Clear the chat first
          chat:clear()

          -- Add initial content after a small delay to ensure clearing is complete
          vim.defer_fn(function()
            -- Get to the end of the buffer and enter insert mode
            local bufnr = vim.api.nvim_get_current_buf()

            -- Check if buffer has content and remove empty lines at the end
            local line_count = vim.api.nvim_buf_line_count(bufnr)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

            -- Find the last non-empty line
            local last_content_line = line_count
            for i = line_count, 1, -1 do
              if lines[i] and lines[i]:match("%S") then
                last_content_line = i
                break
              end
            end

            -- Move cursor to the end of the buffer
            vim.api.nvim_win_set_cursor(0, { last_content_line, 0 })

            -- Add your initial content here - customize this as needed
            local initial_content = {
              table.concat(
                vim.tbl_map(function(tool)
                  return "@{" .. tool .. "}"
                end, default_tools),
                " "
              ),
              "",
              "",
            }

            -- Insert the content after the last content line
            vim.api.nvim_buf_set_lines(bufnr, last_content_line + 1, -1, false, initial_content)

            -- Move cursor to the end and enter insert mode
            local new_line_count = vim.api.nvim_buf_line_count(bufnr)
            vim.api.nvim_win_set_cursor(0, { new_line_count, 0 })
            vim.cmd("startinsert!")
          end, 100)
        end,
        desc = "Clear chat and add initial content",
        mode = { "n", "i" },
        ft = "codecompanion",
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
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Open actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
      {
        "<leader>gc",
        "<cmd>CodeCompanion /write_commit<cr>",
        desc = "Write the git commit for you",
        ft = "gitcommit",
      },
      {
        "<leader>ay",
        function()
          vim.cmd("startinsert")
          vim.api.nvim_input("Please make the change for me!")
        end,
        ft = "codecompanion",
        desc = "Ask AI to make changes with all tools",
        mode = "n",
      },
      {
        "<m-y>",
        function()
          vim.api.nvim_input("Please make the change for me!")
        end,
        ft = "codecompanion",
        desc = "Ask AI to make changes with all tools",
        mode = "i",
      },
    },
  },
}

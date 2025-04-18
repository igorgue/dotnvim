local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local codecompanion_group = augroup("CodeCompanionAutoSave", { clear = true })

local function save_codecompanion_buffer(bufnr)
  local data_path = vim.fn.stdpath("data")
  local save_dir = vim.fn.stdpath("data") .. "/codecompanion"

  vim.fn.mkdir(save_dir, "p")

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Extract the unique ID from the buffer name
  local id = bufname:match("%[CodeCompanion%] (%d+)")
  local date = os.date("%Y-%m-%d")
  local save_path

  if id then
    -- Use date plus ID to ensure uniqueness
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. id .. ".md"
  else
    -- Fallback with timestamp to ensure uniqueness if no ID
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. os.date("%H%M%S") .. ".md"
  end

  -- Write buffer content to file
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local file = io.open(save_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
  end
end

autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
  group = codecompanion_group,
  callback = function(args)
    local bufnr = args.buf
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("%[CodeCompanion%]") then
      save_codecompanion_buffer(bufnr)
    end
  end,
})

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
      "echasnovski/mini.diff",
      { "Davidyz/VectorCode", cmd = "VectorCode" },
      {
        "ravitemer/mcphub.nvim",
        cmd = "MCPHub",
        build = "bundled_build.lua",
        opts = {
          use_bundled_binary = true,
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
    end,
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
                default = "o4-mini",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = vim.g.codecompanion_initial_adapter,
          roles = {
            user = vim.env.USERNAME,
            llm = function(adapter)
              if not (adapter and adapter.schema and adapter.schema.model) then
                return "CodeCompanion"
              end

              return "CodeCompanion (" .. adapter.formatted_name .. ":" .. adapter.schema.model.default .. ")"
            end,
          },
          keymaps = {
            send = {
              modes = { i = "<S-CR>", n = "<CR>" },
            },
            clear = {
              modes = {
                i = "<C-del>",
                n = "<C-del>",
              },
            },
            close = {
              modes = { n = {}, i = {} },
            },
            stop = {
              modes = { n = "<C-c>", i = "<C-c>" },
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
            mcp = {
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
            },
          },
        },
        inline = { adapter = vim.g.codecompanion_initial_inline_adapter },
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
          show_references = true,
          show_header_separator = true,
          show_settings = false,
          render_headers = false,
          start_in_insert_mode = false,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      prompt_library = {
        ["Write Commit Message"] = {
          strategy = "inline",
          description = "Writes commit message on gitcommit buffer",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "write_commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please @editor generate a commit message for me inside of the current #buffer:

```diff
%s
```]],
                  vim.fn.system("git diff --no-ext-diff --staged")
                )
              end,
              opts = {
                contains_code = true,
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
```]],
                  vim.fn.system("git diff --no-ext-diff")
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    keys = {
      { "<C-;>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle (CopilotChatToggle)", mode = { "n", "v", "i" } },
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
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion Chat", mode = { "n", "v" } },
      -- stylua: ignore
      { "<leader>af", function() Snacks.picker.files({ cwd = vim.fn.stdpath("data") .. "/codecompanion" }) end, desc = "Find Previous Chats" },
    },
  },
}

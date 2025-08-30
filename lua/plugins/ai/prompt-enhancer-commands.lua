-- Utility commands for managing prompt enhancement in CodeCompanion
-- This module provides convenient commands to control the prompt enhancement feature

local M = {}

-- Toggle prompt enhancement on/off
function M.toggle_enhancement()
  local config = require("codecompanion.config")
  local current = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement", "enabled")

  if current == nil then
    -- If not set, default to true (assuming it should be enabled)
    current = true
  end

  local new_state = not current

  -- Update the configuration
  if not config.strategies then config.strategies = {} end
  if not config.strategies.chat then config.strategies.chat = {} end
  if not config.strategies.chat.opts then config.strategies.chat.opts = {} end
  if not config.strategies.chat.opts.prompt_enhancement then config.strategies.chat.opts.prompt_enhancement = {} end
  config.strategies.chat.opts.prompt_enhancement.enabled = new_state

  local status = new_state and "enabled" or "disabled"
  vim.notify(string.format("Prompt enhancement %s", status), vim.log.levels.INFO)
end

-- Set the enhancement model
function M.set_enhancement_model(model)
  local config = require("codecompanion.config")
  if not config.strategies then config.strategies = {} end
  if not config.strategies.chat then config.strategies.chat = {} end
  if not config.strategies.chat.opts then config.strategies.chat.opts = {} end
  if not config.strategies.chat.opts.prompt_enhancement then config.strategies.chat.opts.prompt_enhancement = {} end
  config.strategies.chat.opts.prompt_enhancement.model = model
  vim.notify(string.format("Prompt enhancement model set to: %s", model), vim.log.levels.INFO)
end

-- Set the enhancement timeout
function M.set_timeout(timeout_str)
  local timeout = tonumber(timeout_str)
  if not timeout or timeout <= 0 then
    vim.notify("Invalid timeout value. Please provide a positive number in milliseconds.", vim.log.levels.ERROR)
    return
  end
  
  local config = require("codecompanion.config")
  if not config.strategies then config.strategies = {} end
  if not config.strategies.chat then config.strategies.chat = {} end
  if not config.strategies.chat.opts then config.strategies.chat.opts = {} end
  if not config.strategies.chat.opts.prompt_enhancement then config.strategies.chat.opts.prompt_enhancement = {} end
  config.strategies.chat.opts.prompt_enhancement.timeout = timeout
  vim.notify(string.format("Prompt enhancement timeout set to: %d ms", timeout), vim.log.levels.INFO)
end

-- Toggle debug mode for enhancement
function M.toggle_debug()
  local config = require("codecompanion.config")
  local current = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement", "debug")

  if current == nil then
    current = false
  end

  local new_state = not current
  if not config.strategies then config.strategies = {} end
  if not config.strategies.chat then config.strategies.chat = {} end
  if not config.strategies.chat.opts then config.strategies.chat.opts = {} end
  if not config.strategies.chat.opts.prompt_enhancement then config.strategies.chat.opts.prompt_enhancement = {} end
  config.strategies.chat.opts.prompt_enhancement.debug = new_state

  local status = new_state and "enabled" or "disabled"
  vim.notify(string.format("Prompt enhancement debug %s", status), vim.log.levels.INFO)
end

-- Show current enhancement configuration
function M.show_config()
  local config = require("codecompanion.config")
  local enhancement_config = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement") or {}

  local lines = {
    "=== Prompt Enhancement Configuration ===",
    string.format("Enabled: %s", enhancement_config.enabled and "Yes" or "No"),
    string.format("Model: %s", enhancement_config.model or "Not set"),
    string.format("Timeout: %d ms", enhancement_config.timeout or 3000),
    string.format("Debug: %s", enhancement_config.debug and "Yes" or "No"),
  }

  -- Check Ollama status
  local enhancer = require("plugins.ai.prompt-enhancer")
  local ollama_status = enhancer.check_ollama_status() and "Running" or "Not running"
  table.insert(lines, string.format("Ollama Status: %s", ollama_status))

  -- List available models
  local models = enhancer.list_models()
  if #models > 0 then
    table.insert(lines, "Available Models:")
    for _, model in ipairs(models) do
      table.insert(lines, "  - " .. model)
    end
  else
    table.insert(lines, "No Ollama models found")
  end

  -- Display in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local width = 60
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Prompt Enhancement Status ",
    title_pos = "center",
  })

  -- Close window on any key press
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end

-- Test enhancement with a sample prompt
function M.test_enhancement()
  local enhancer = require("plugins.ai.prompt-enhancer")
  local config = require("codecompanion.config")
  local enhancement_config = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement") or {}

  -- Get user input
  vim.ui.input({
    prompt = "Enter a prompt to test enhancement: ",
    default = "fix the bug in my code",
  }, function(input)
    if not input or input == "" then
      return
    end

    -- Test the enhancement
    local enhanced = enhancer.enhance_prompt(input, enhancement_config)

    -- Show results
    local lines = {
      "=== Prompt Enhancement Test ===",
      "",
      "Original:",
      input,
      "",
      "Enhanced:",
      enhanced,
    }

    -- Display in a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    local width = math.min(80, math.max(40, math.max(#input, #enhanced) + 10))
    local height = #lines
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      title = " Enhancement Test Result ",
      title_pos = "center",
    })

    -- Close window on key press
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  end)
end

-- Setup function to create user commands
function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command("CCPromptEnhanceToggle", M.toggle_enhancement, {
    desc = "Toggle prompt enhancement on/off",
  })

  vim.api.nvim_create_user_command("CCPromptEnhanceModel", function(opts)
    M.set_enhancement_model(opts.args)
  end, {
    nargs = 1,
    desc = "Set the Ollama model for prompt enhancement",
    complete = function()
      local enhancer = require("plugins.ai.prompt-enhancer")
      return enhancer.list_models()
    end,
  })

  vim.api.nvim_create_user_command("CCPromptEnhanceDebug", M.toggle_debug, {
    desc = "Toggle debug mode for prompt enhancement",
  })

  vim.api.nvim_create_user_command("CCPromptEnhanceStatus", M.show_config, {
    desc = "Show prompt enhancement configuration and status",
  })

  vim.api.nvim_create_user_command("CCPromptEnhanceTest", M.test_enhancement, {
    desc = "Test prompt enhancement with a sample prompt",
  })
  
  vim.api.nvim_create_user_command("CCPromptEnhanceTimeout", function(opts)
    if opts.args == "" then
      local config = require("codecompanion.config")
      local timeout = vim.tbl_get(config, "strategies", "chat", "opts", "prompt_enhancement", "timeout") or 3000
      vim.notify(string.format("Current timeout: %d ms", timeout), vim.log.levels.INFO)
    else
      M.set_timeout(opts.args)
    end
  end, {
    nargs = "?",
    desc = "Set or show the timeout for prompt enhancement (in milliseconds)",
  })
  
  -- Test code block extraction
  vim.api.nvim_create_user_command("CCPromptTestExtraction", function()
    local enhancer = require("plugins.ai.prompt-enhancer")
    
    -- Get user input
    vim.ui.input({
      prompt = "Enter text with code blocks to test extraction: ",
      default = [[Here's my code:
```python
def hello():
    print("Hello, World!")
```
And some inline `code here` too.]],
    }, function(input)
      if not input or input == "" then
        return
      end
      
      -- Test extraction
      local stripped, blocks = enhancer.extract_code_blocks(input)
      
      -- Show results
      local lines = {
        "=== Code Block Extraction Test ===",
        "",
        "Original text:",
        input,
        "",
        "Text after extraction:",
        stripped,
        "",
        "Extracted blocks:",
      }
      
      for placeholder, code in pairs(blocks) do
        table.insert(lines, string.format("%s -> %s", placeholder, vim.inspect(code)))
      end
      
      -- Display in a floating window
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      
      local width = 80
      local height = math.min(30, #lines)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      
      vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " Code Extraction Test ",
        title_pos = "center",
      })
      
      -- Close window on key press
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    end)
  end, {
    desc = "Test code block extraction",
  })
end

-- Auto-setup when module is required
M.setup()

return M

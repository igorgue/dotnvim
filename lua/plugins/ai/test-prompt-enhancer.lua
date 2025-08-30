-- Test script for the prompt enhancer
-- Run this with :luafile % or :source % in Neovim

local function test_prompt_enhancer()
  -- Load the enhancer module
  local ok, enhancer = pcall(require, "plugins.ai.prompt-enhancer")
  if not ok then
    vim.notify("Failed to load prompt enhancer module", vim.log.levels.ERROR)
    return
  end

  -- Test configuration
  local test_config = {
    enabled = true,
    model = "llama3.2", -- Change this to a model you have installed
    debug = true, -- Enable debug output
    timeout = 5000,
  }

  -- Test 1: Check Ollama status
  print("\n=== Test 1: Checking Ollama status ===")
  local ollama_running = enhancer.check_ollama_status()
  if ollama_running then
    print("✓ Ollama is running")
  else
    print("✗ Ollama is not running. Please start Ollama with: ollama serve")
    return
  end

  -- Test 2: List available models
  print("\n=== Test 2: Listing available models ===")
  local models = enhancer.list_models()
  if #models > 0 then
    print("Available models:")
    for _, model in ipairs(models) do
      print("  - " .. model)
    end
  else
    print("✗ No models found. Please pull a model with: ollama pull llama3.2")
    return
  end

  -- Test 3: Test synchronous enhancement
  print("\n=== Test 3: Testing synchronous enhancement ===")
  local test_prompts = {
    "fix bug",
    "make website responsive",
    "explain this code",
    "help me debug",
    "write unit tests for the calculate function",
  }

  for _, prompt in ipairs(test_prompts) do
    print("\nOriginal: " .. prompt)
    local enhanced = enhancer.enhance_prompt(prompt, test_config)
    print("Enhanced: " .. enhanced)
    print("---")
  end

  -- Test 4: Test async enhancement
  print("\n=== Test 4: Testing async enhancement ===")
  local async_prompt = "optimize database query"
  print("Original: " .. async_prompt)

  enhancer.enhance_prompt_async(async_prompt, test_config, function(result)
    print("Async Enhanced: " .. result)
  end)

  -- Test 5: Test with enhancement disabled
  print("\n=== Test 5: Testing with enhancement disabled ===")
  local disabled_config = vim.tbl_extend("force", test_config, { enabled = false })
  local original = "test prompt"
  local result = enhancer.enhance_prompt(original, disabled_config)
  if result == original then
    print("✓ Correctly returned original when disabled")
  else
    print("✗ Should have returned original when disabled")
  end

  -- Test 6: Test fallback on error (simulate with wrong endpoint)
  print("\n=== Test 6: Testing fallback on error ===")
  local error_config = vim.tbl_extend("force", test_config, {
    endpoint = "http://localhost:99999/api/generate", -- Invalid port
    timeout = 1000,
    debug = false, -- Disable debug to avoid error spam
  })
  local fallback_test = "test fallback"
  local fallback_result = enhancer.enhance_prompt(fallback_test, error_config)
  if fallback_result == fallback_test then
    print("✓ Correctly fell back to original on error")
  else
    print("✗ Should have fallen back to original on error")
  end

  print("\n=== All tests completed ===")
end

-- Create a command to run the tests
vim.api.nvim_create_user_command("TestPromptEnhancer", test_prompt_enhancer, {})

-- Run the tests immediately if this file is sourced
test_prompt_enhancer()

-- You can also test it directly in CodeCompanion by:
-- 1. Opening a chat with :CodeCompanionChat
-- 2. Typing a simple prompt like "fix bug"
-- 3. Sending it and checking if it gets enhanced
--
-- To toggle enhancement on/off, you can modify the config:
-- :lua require("codecompanion.config").strategies.chat.opts.prompt_enhancement.enabled = false

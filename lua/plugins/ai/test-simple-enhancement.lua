-- Simple test to verify prompt enhancement
local function test_enhancement()
  print("\n=== Testing Prompt Enhancement ===\n")
  
  -- Load the enhancer
  local ok, enhancer = pcall(require, "plugins.ai.prompt-enhancer")
  if not ok then
    print("❌ Failed to load enhancer module")
    return
  end
  print("✅ Enhancer module loaded")
  
  -- Check Ollama
  local ollama_ok = enhancer.check_ollama_status()
  if ollama_ok then
    print("✅ Ollama is running")
  else
    print("❌ Ollama is not running")
    return
  end
  
  -- Test with a simple prompt
  local test_prompt = "Hello"
  local config = {
    enabled = true,
    model = "codellama:7b",
    debug = true,
    timeout = 10000, -- 10 seconds
  }
  
  print("\n📝 Original prompt: " .. test_prompt)
  print("⏳ Enhancing prompt (this may take a few seconds)...")
  
  local enhanced = enhancer.enhance_prompt(test_prompt, config)
  
  print("\n✨ Enhanced prompt: " .. enhanced)
  
  if enhanced == test_prompt then
    print("\n⚠️  The prompt was not enhanced (returned original)")
  else
    print("\n✅ Enhancement successful!")
  end
end

-- Run the test
test_enhancement()

return test_enhancement

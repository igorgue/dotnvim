-- Prompt Enhancer Module for CodeCompanion
-- This module uses Ollama to enhance user prompts before sending them to the main LLM
-- It provides async prompt enhancement with fallback to original prompt on failure

local M = {}

-- Extract code blocks from text and replace with placeholders
-- Returns the modified text and a table of extracted code blocks
function M.extract_code_blocks(text)
  local code_blocks = {}
  local block_counter = 0

  -- First, handle triple backtick code blocks
  -- This pattern is more robust and handles multiline code blocks
  local modified_text = text
  local pattern = "```[^\n]*\n(.-)\n```"

  -- Use a while loop to find all code blocks
  local start_pos = 1
  while true do
    local block_start, block_end, lang_and_code = string.find(modified_text, "```([^`]-)```", start_pos)
    if not block_start then
      break
    end

    block_counter = block_counter + 1
    local placeholder_key = string.format("__CODE_BLOCK_%d__", block_counter)

    -- Store the entire code block including the backticks
    code_blocks[placeholder_key] = string.sub(modified_text, block_start, block_end)

    -- Replace the code block with placeholder
    modified_text = string.sub(modified_text, 1, block_start - 1)
      .. placeholder_key
      .. string.sub(modified_text, block_end + 1)

    -- Update start position for next search
    start_pos = block_start + #placeholder_key
  end

  -- Also handle inline code (single backticks) if they're substantial
  modified_text = modified_text:gsub("`([^`]+)`", function(code_content)
    -- Only extract inline code if it's longer than 30 characters
    -- to avoid extracting simple variable names or short snippets
    if #code_content > 30 then
      block_counter = block_counter + 1
      local placeholder_key = string.format("__INLINE_CODE_%d__", block_counter)
      code_blocks[placeholder_key] = string.format("`%s`", code_content)
      return placeholder_key
    else
      -- Keep short inline code as-is
      return string.format("`%s`", code_content)
    end
  end)

  return modified_text, code_blocks
end

-- Restore code blocks in text using the provided table
function M.restore_code_blocks(text, code_blocks)
  if not code_blocks or vim.tbl_isempty(code_blocks) then
    return text
  end

  local restored_text = text

  -- Replace each placeholder with its original code block
  for placeholder, code_block in pairs(code_blocks) do
    -- Use plain string replacement to avoid pattern matching issues
    restored_text = restored_text:gsub(placeholder, function()
      return code_block
    end)
  end

  return restored_text
end

-- Default configuration
M.config = {
  enabled = true, -- Enable/disable prompt enhancement
  model = "gemma3:12b", -- Ollama model to use for enhancement
  endpoint = "http://localhost:11434/api/generate", -- Ollama API endpoint
  timeout = 30000, -- Timeout in milliseconds
  max_tokens = 500, -- Maximum tokens for enhanced prompt

  -- System prompt for enhancement
  enhancement_prompt = [[You are an expert prompt engineer. Your task is to improve the user's prompt to get better results from an AI assistant.

Guidelines:
1. Make the prompt clear and specific
2. Add relevant context if needed
3. Break down complex requests into clear steps
4. Ensure the prompt is well-structured
5. Keep the original intent intact
6. Don't make it overly verbose
7. Preserve tool calling like @{toolname} if present in the original prompt also #{variables} and / (slash commands), add tools if you can.
8. Do not modify the code in the prompt or providing an answer, code is usually wrapped between ``` (triple backticks), and single lines with ` (single backtick), unless the user specifically asks for code changes, focus on improving the prompt itself.
9. If the prompt includes a tool without call it, for example "Wikipedia" then you can replace that with the tool "@{wikipedia}".

Original prompt:

```
%s
```

Return ONLY the enhanced prompt without any explanation or additional text.
]],

  -- Optional: Log enhanced prompts for debugging
  debug = false,
}

-- Local cache for plenary.curl
local curl = nil
local function get_curl()
  if not curl then
    local ok, plenary_curl = pcall(require, "plenary.curl")
    if ok then
      curl = plenary_curl
    else
      vim.notify("plenary.curl not found. Please ensure plenary.nvim is installed.", vim.log.levels.ERROR)
      return nil
    end
  end
  return curl
end

-- Parse streaming JSON response from Ollama
local function parse_streaming_response(response_text)
  local result = ""
  -- Split by newlines to handle streaming JSON
  for line in response_text:gmatch("[^\r\n]+") do
    if line ~= "" then
      local ok, json = pcall(vim.json.decode, line)
      if ok and json.response then
        result = result .. json.response
      end
    end
  end
  return result
end

-- Enhance a prompt using Ollama (synchronous for simplicity in prompt_decorator)
function M.enhance_prompt(prompt, config)
  config = vim.tbl_deep_extend("force", M.config, config or {})

  -- Check if enhancement is enabled
  if not config.enabled then
    return prompt
  end

  local curl_lib = get_curl()
  if not curl_lib then
    return prompt -- Fallback to original if plenary.curl not available
  end

  -- Extract code blocks before enhancement to avoid sending them to the LLM
  local prompt_without_code, code_blocks = M.extract_code_blocks(prompt)

  if config.debug then
    if next(code_blocks) then
      vim.notify(
        string.format("Extracted %d code blocks before enhancement", vim.tbl_count(code_blocks)),
        vim.log.levels.INFO
      )
      vim.notify(
        string.format("Original length: %d, Stripped length: %d", #prompt, #prompt_without_code),
        vim.log.levels.INFO
      )
    else
      vim.notify("No code blocks found to extract", vim.log.levels.INFO)
    end
    vim.notify(string.format("Prompt being sent to Ollama: %s", prompt_without_code), vim.log.levels.DEBUG)
  end

  -- Prepare the request with the code-stripped prompt
  local formatted_prompt = string.format(config.enhancement_prompt, prompt_without_code)
  local request_body = vim.json.encode({
    model = config.model,
    prompt = formatted_prompt,
    stream = false, -- Using non-streaming for simpler synchronous handling
    options = {
      num_predict = config.max_tokens,
      temperature = 0.7,
      top_p = 0.9,
    },
  })

  if config.debug then
    vim.notify(string.format("Enhancing prompt with Ollama model: %s", config.model), vim.log.levels.INFO)
  end

  -- Make the synchronous request
  local response = curl_lib.post(config.endpoint, {
    body = request_body,
    headers = {
      ["Content-Type"] = "application/json",
    },
    timeout = config.timeout,
  })

  -- Check for successful response
  if response and response.status == 200 and response.body then
    local ok, json = pcall(vim.json.decode, response.body)
    if ok and json.response then
      local enhanced = vim.trim(json.response)

      -- Restore code blocks to the enhanced prompt
      enhanced = M.restore_code_blocks(enhanced, code_blocks)

      if config.debug then
        vim.notify(string.format("Original: %s\nEnhanced: %s", prompt, enhanced), vim.log.levels.INFO)
      end

      -- Only return enhanced if it's not empty and different from original
      if enhanced ~= "" and enhanced ~= prompt then
        return enhanced
      end
    end
  elseif config.debug then
    vim.notify(
      string.format("Ollama enhancement failed: %s", response and response.status or "no response"),
      vim.log.levels.WARN
    )
  end

  -- Fallback to original prompt if enhancement fails
  return prompt
end

-- Async version using vim.schedule for better UI responsiveness
function M.enhance_prompt_async(prompt, config, callback)
  config = vim.tbl_deep_extend("force", M.config, config or {})

  -- Check if enhancement is enabled
  if not config.enabled then
    callback(prompt)
    return
  end

  local curl_lib = get_curl()
  if not curl_lib then
    callback(prompt) -- Fallback to original if plenary.curl not available
    return
  end

  -- Extract code blocks before enhancement to avoid sending them to the LLM
  local prompt_without_code, code_blocks = M.extract_code_blocks(prompt)

  if config.debug and next(code_blocks) then
    vim.notify(
      string.format("Async: Extracted %d code blocks before enhancement", vim.tbl_count(code_blocks)),
      vim.log.levels.INFO
    )
  end

  -- Run in a separate thread to avoid blocking
  vim.schedule(function()
    -- Prepare the request with the code-stripped prompt
    local formatted_prompt = string.format(config.enhancement_prompt, prompt_without_code)
    local request_body = vim.json.encode({
      model = config.model,
      prompt = formatted_prompt,
      stream = false,
      options = {
        num_predict = config.max_tokens,
        temperature = 0.7,
        top_p = 0.9,
      },
    })

    if config.debug then
      vim.notify(string.format("Async enhancing prompt with Ollama model: %s", config.model), vim.log.levels.INFO)
    end

    -- Make the async request
    curl_lib.post(config.endpoint, {
      body = request_body,
      headers = {
        ["Content-Type"] = "application/json",
      },
      timeout = config.timeout,
      callback = vim.schedule_wrap(function(response)
        -- Check for successful response
        if response and response.status == 200 and response.body then
          local ok, json = pcall(vim.json.decode, response.body)
          if ok and json.response then
            local enhanced = vim.trim(json.response)

            -- Restore code blocks to the enhanced prompt
            enhanced = M.restore_code_blocks(enhanced, code_blocks)

            if config.debug then
              vim.notify(string.format("Async enhanced: %s", enhanced), vim.log.levels.INFO)
            end

            -- Only return enhanced if it's not empty and different from original
            if enhanced ~= "" and enhanced ~= prompt then
              callback(enhanced)
              return
            end
          end
        elseif config.debug then
          vim.notify(
            string.format("Async Ollama enhancement failed: %s", response and response.status or "no response"),
            vim.log.levels.WARN
          )
        end

        -- Fallback to original prompt if enhancement fails
        callback(prompt)
      end),
    })
  end)
end

-- Setup function to configure the module
function M.setup(config)
  M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

-- Helper function to check if Ollama is running
function M.check_ollama_status()
  local curl_lib = get_curl()
  if not curl_lib then
    return false
  end

  local response = curl_lib.get("http://localhost:11434/api/tags", {
    timeout = M.config.timeout,
  })

  return response and response.status == 200
end

-- List available models from Ollama
function M.list_models()
  local curl_lib = get_curl()
  if not curl_lib then
    return {}
  end

  local response = curl_lib.get("http://localhost:11434/api/tags", {
    timeout = M.config.timeout,
  })

  if response and response.status == 200 and response.body then
    local ok, json = pcall(vim.json.decode, response.body)
    if ok and json.models then
      local models = {}
      for _, model in ipairs(json.models) do
        table.insert(models, model.name)
      end
      return models
    end
  end

  return {}
end

return M

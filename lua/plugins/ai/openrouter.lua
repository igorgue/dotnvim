local log = require("codecompanion.utils.log")
local utils = require("codecompanion.utils.adapters")

---Remove any keys from the message that are not allowed by the API
---@param message table The message to filter
---@return table The filtered message
local function filter_out_messages(message)
  local allowed = {
    "content",
    "role",
    "tool_calls",
    "tool_call_id",
  }

  for key, _ in pairs(message) do
    if not vim.tbl_contains(allowed, key) then
      message[key] = nil
    end
  end
  return message
end

---@class OpenRouter.Adapter: CodeCompanion.Adapter
return {
  name = "openrouter",
  formatted_name = "Open Router",
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
  url = "${url}${chat_url}",
  env = {
    api_key = "OPENAI_API_KEY",
    url = "https://openrouter.ai/api",
    chat_url = "/v1/chat/completions",
    models_endpoint = "/v1/models",
  },
  headers = {
    ["Content-Type"] = "application/json",
    Authorization = "Bearer ${api_key}",
  },
  temp = {},
  handlers = {
    ---@param self CodeCompanion.Adapter
    ---@return boolean
    setup = function(self)
      local model = self.schema.model.default
      if type(model) == "function" then
        model = model(self)
      end
      local model_opts = self.schema.model.choices
      if type(model_opts) == "function" then
        model_opts = model_opts(self)
      end

      self.opts.vision = true

      if model_opts and model_opts[model] and model_opts[model].opts then
        self.opts = vim.tbl_deep_extend("force", self.opts, model_opts[model].opts)

        if not model_opts[model].opts.has_vision then
          self.opts.vision = false
        end
      end

      if self.opts and self.opts.stream then
        self.parameters.stream = true
        self.parameters.stream_options = { include_usage = true }
      end

      return true
    end,

    ---Set the parameters
    ---@param self CodeCompanion.Adapter
    ---@param params table
    ---@param messages table
    ---@return table
    form_parameters = function(self, params, messages)
      if self.temp.reasoning_effort then
        params.reasoning = {
          -- effort = self.temp.reasoning_effort,
          max_tokens = self.temp.reasoning_max_tokens,
        }
      end

      return params
    end,

    ---Set the format of the role and content for the messages from the chat buffer
    ---@param self CodeCompanion.Adapter
    ---@param messages table Format is: { { role = "user", content = "Your prompt here" } }
    ---@return table
    form_messages = function(self, messages)
      local model = self.schema.model.default
      if type(model) == "function" then
        model = model(self)
      end

      local out = {}
      for _, m in ipairs(messages) do
        -- Adjust role for certain models
        if vim.startswith(model, "o1") and m.role == "system" then
          m.role = self.roles.user
        end

        -- Ensure tool_calls are clean
        if m.tool_calls then
          m.tool_calls = vim
            .iter(m.tool_calls)
            :map(function(tool_call)
              return { id = tool_call.id, ["function"] = tool_call["function"], type = tool_call.type }
            end)
            :totable()
        end

        -- Process any images
        if m.opts and m.opts.tag == "image" and m.opts.mimetype then
          if self.opts and self.opts.vision then
            m.content = {
              {
                type = "image_url",
                image_url = { url = string.format("data:%s;base64,%s", m.opts.mimetype, m.content) },
              },
            }
          else
            -- Skip images when vision unsupported
            goto continue
          end
        end

        -- 1) Emit reasoning as its own assistant message
        if m.reasoning and m.reasoning.content then
          local reasoning_msg = {
            role = self.roles.user,
            content = "### please consider the following reasonig when answering:\n" .. m.reasoning.content,
          }
          reasoning_msg = filter_out_messages(reasoning_msg)
          table.insert(out, reasoning_msg)
        end

        -- 2) Emit the actual content message
        m = filter_out_messages(m)
        table.insert(
          out,
          { role = m.role, content = m.content, tool_calls = m.tool_calls, tool_call_id = m.tool_call_id }
        )
        ::continue::
      end

      return { messages = out }
    end,

    ------Form the reasoning output that is stored in the chat buffer
    ------@param self CodeCompanion.Adapter
    ------@param data table The reasoning output from the LLM
    ------@return nil|{ content: string, _data: table }
    form_reasoning = function(self, data)
      local content = vim
        .iter(data)
        :map(function(item)
          return item.content
        end)
        :filter(function(content)
          return content ~= nil
        end)
        :join("")

      return {
        content = content,
      }
    end,

    ---Provides the schemas of the tools that are available to the LLM to call
    ---@param self CodeCompanion.Adapter
    ---@param tools table<string, table>
    ---@return table|nil
    form_tools = function(self, tools)
      if not self.opts.tools or not tools then
        return
      end
      if vim.tbl_count(tools) == 0 then
        return
      end

      local transformed = {}
      for _, tool in pairs(tools) do
        for _, schema in pairs(tool) do
          table.insert(transformed, schema)
        end
      end

      return { tools = transformed }
    end,

    ---Returns the number of tokens generated from the LLM
    ---@param self CodeCompanion.Adapter
    ---@param data table The data from the LLM
    ---@return number|nil
    tokens = function(self, data)
      if data and data ~= "" then
        local data_mod = utils.clean_streamed_data(data)
        local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

        if ok then
          if json.usage then
            local tokens = json.usage.total_tokens
            log:trace("Tokens: %s", tokens)
            return tokens
          end
        end
      end
    end,

    ---Output the data from the API ready for insertion into the chat buffer
    ---@param self CodeCompanion.Adapter
    ---@param data table The streamed JSON data from the API, also formatted by the format_data handler
    ---@param tools? table The table to write any tool output to
    ---@return { status: string, output: { role: string, content: string, reasoning: string? } } | nil
    chat_output = function(self, data, tools)
      local output = {}

      if not data or data == "" then
        return nil
      end

      -- Handle both streamed data and structured response
      local data_mod = type(data) == "table" and data.body or utils.clean_streamed_data(data)
      local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

      if not ok or not json.choices or #json.choices == 0 then
        return nil
      end

      -- Process tool calls from all choices
      if self.opts.tools and tools then
        for _, choice in ipairs(json.choices) do
          local delta = self.opts.stream and choice.delta or choice.message

          if delta and delta.tool_calls and #delta.tool_calls > 0 then
            for i, tool in ipairs(delta.tool_calls) do
              local tool_index = tool.index and tonumber(tool.index) or i

              -- Some endpoints like Gemini do not set this (why?!)
              local id = tool.id
              if not id or id == "" then
                id = string.format("call_%s_%s", json.created, i)
              end

              if self.opts.stream then
                local found = false
                for _, existing_tool in ipairs(tools) do
                  if existing_tool._index == tool_index then
                    -- Append to arguments if this is a continuation of a stream
                    if tool["function"] and tool["function"]["arguments"] then
                      existing_tool["function"]["arguments"] = (existing_tool["function"]["arguments"] or "")
                        .. tool["function"]["arguments"]
                    end
                    found = true
                    break
                  end
                end

                if not found then
                  table.insert(tools, {
                    _index = tool_index,
                    id = id,
                    type = tool.type,
                    ["function"] = {
                      name = tool["function"]["name"],
                      arguments = tool["function"]["arguments"] or "",
                    },
                  })
                end
              else
                table.insert(tools, {
                  _index = i,
                  id = id,
                  type = tool.type,
                  ["function"] = {
                    name = tool["function"]["name"],
                    arguments = tool["function"]["arguments"],
                  },
                })
              end
            end
          end
        end
      end

      -- Process message content from the first choice
      local choice = json.choices[1]
      local delta = self.opts.stream and choice.delta or choice.message

      if not delta then
        return nil
      end

      local can_reason = false
      if self.temp.reasoning_effort then
        can_reason = true
      end

      if can_reason and delta.reasoning then
        output.reasoning = output.reasoning or {}
        output.reasoning.content = (output.reasoning.content or "") .. delta.reasoning
        output.role = delta.role
        return { status = "success", output = output }
      end

      if delta.content then
        output.role = delta.role
        output.content = delta.content
        return { status = "success", output = output }
      end

      return nil
    end,

    ---Output the data from the API ready for inlining into the current buffer
    ---@param self CodeCompanion.Adapter
    ---@param data string|table The streamed JSON data from the API, also formatted by the format_data handler
    ---@param context? table Useful context about the buffer to inline to
    ---@return {status: string, output: table}|nil
    inline_output = function(self, data, context)
      if self.opts.stream then
        return log:error("Inline output is not supported for non-streaming models")
      end

      if data and data ~= "" then
        local ok, json = pcall(vim.json.decode, data.body, { luanil = { object = true } })

        if not ok then
          log:error("Error decoding JSON: %s", data.body)
          return { status = "error", output = json }
        end

        local choice = json.choices[1]
        if choice.message.content then
          return { status = "success", output = choice.message.content }
        end
      end
    end,
    tools = {
      ---Format the LLM's tool calls for inclusion back in the request
      ---@param self CodeCompanion.Adapter
      ---@param tools table The raw tools collected by chat_output
      ---@return table
      format_tool_calls = function(self, tools)
        -- Source: https://platform.openai.com/docs/guides/function-calling?api-mode=chat#handling-function-calls
        return tools
      end,

      ---Output the LLM's tool call so we can include it in the messages
      ---@param self CodeCompanion.Adapter
      ---@param tool_call {id: string, function: table, name: string}
      ---@param output string
      ---@return table
      output_response = function(self, tool_call, output)
        -- Source: https://platform.openai.com/docs/guides/function-calling?api-mode=chat#handling-function-calls
        return {
          role = self.roles.tool or "tool",
          tool_call_id = tool_call.id,
          content = output,
          opts = { visible = false },
        }
      end,
    },

    ---Function to run when the request has completed. Useful to catch errors
    ---@param self CodeCompanion.Adapter
    ---@param data? table
    ---@return nil
    on_exit = function(self, data)
      if data and data.status >= 400 then
        log:error("Error: %s", data.body)
      end
    end,
  },
  schema = {
    model = {
      order = 1,
      mapping = "parameters",
      type = "enum",
      desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
      default = "openai/o4-mini",
      choices = {
        ["openai/o4-mini"] = { opts = { can_reason = true, has_vision = true } },
        ["deepseek/deepseek-r1-0528"] = { opts = { can_reason = true, has_vision = true } },
        ["moonshotai/kimi-k2"] = { opts = { can_reason = false, has_vision = true } },
        ["qwen/qwen3-coder"] = { opts = { can_reason = false, has_vision = true } },
        ["z-ai/glm-4.5"] = { opts = { can_reason = true, has_vision = false } },
      },
    },
    reasoning_effort = {
      order = 2,
      mapping = "temp",
      type = "string",
      optional = true,
      condition = function(self)
        local model = self.schema.model.default
        if type(model) == "function" then
          model = model()
        end
        if self.schema.model.choices[model] and self.schema.model.choices[model].opts then
          return self.schema.model.choices[model].opts.can_reason
        end
        return false
      end,
      default = "medium",
      desc = "Constrains effort on reasoning for reasoning models. Reducing reasoning effort can result in faster responses and fewer tokens used on reasoning in a response.",
      choices = {
        "high",
        "medium",
        "low",
      },
    },
    reasoning_max_tokens = {
      order = 3,
      mapping = "temp",
      type = "number",
      optional = true,
      condition = function(self)
        local model = self.schema.model.default
        if type(model) == "function" then
          model = model()
        end
        if self.schema.model.choices[model] and self.schema.model.choices[model].opts then
          return self.schema.model.choices[model].opts.can_reason
        end
        return false
      end,
      default = 600,
      desc = "Max tokens for reasoning",
    },
    temperature = {
      order = 4,
      mapping = "parameters",
      type = "number",
      optional = true,
      default = 1,
      desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
      validate = function(n)
        return n >= 0 and n <= 2, "Must be between 0 and 2"
      end,
    },
    top_p = {
      order = 5,
      mapping = "parameters",
      type = "number",
      optional = true,
      default = 1,
      desc = "An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both.",
      validate = function(n)
        return n >= 0 and n <= 1, "Must be between 0 and 1"
      end,
    },
    stop = {
      order = 6,
      mapping = "parameters",
      type = "list",
      optional = true,
      default = nil,
      subtype = {
        type = "string",
      },
      desc = "Up to 4 sequences where the API will stop generating further tokens.",
      validate = function(l)
        return #l >= 1 and #l <= 4, "Must have between 1 and 4 elements"
      end,
    },
    max_tokens = {
      order = 7,
      mapping = "parameters",
      type = "integer",
      optional = true,
      default = nil,
      desc = "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
      validate = function(n)
        return n > 0, "Must be greater than 0"
      end,
    },
    presence_penalty = {
      order = 8,
      mapping = "parameters",
      type = "number",
      optional = true,
      default = 0,
      desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.",
      validate = function(n)
        return n >= -2 and n <= 2, "Must be between -2 and 2"
      end,
    },
    frequency_penalty = {
      order = 9,
      mapping = "parameters",
      type = "number",
      optional = true,
      default = 0,
      desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.",
      validate = function(n)
        return n >= -2 and n <= 2, "Must be between -2 and 2"
      end,
    },
    logit_bias = {
      order = 10,
      mapping = "parameters",
      type = "map",
      optional = true,
      default = nil,
      desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
      subtype_key = {
        type = "integer",
      },
      subtype = {
        type = "integer",
        validate = function(n)
          return n >= -100 and n <= 100, "Must be between -100 and 100"
        end,
      },
    },
    user = {
      order = 111,
      mapping = "parameters",
      type = "string",
      optional = true,
      default = nil,
      desc = "A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. Learn more.",
      validate = function(u)
        return u:len() < 100, "Cannot be longer than 100 characters"
      end,
    },
  },
}

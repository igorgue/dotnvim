-- System prompt generator for CodeCompanion AI assistant
-- This module creates dynamic system prompts with system information for AI interactions
local utils = require("utils")

--- Get OS uname information with fallback for older Neovim versions
--- @return table OS information
local function get_uname()
  if vim.uv and vim.uv.os_uname then
    return vim.uv.os_uname()
  elseif vim.loop and vim.loop.os_uname then
    return vim.loop.os_uname()
  else
    return { sysname = "Unknown", release = "Unknown" }
  end
end

--- Safely execute a system command and return the output or a fallback value
--- @param cmd string The command to execute
--- @param fallback string? The fallback value if command fails
--- @return string The command output or fallback
local function safe_system_cmd(cmd, fallback)
  local ok, result = pcall(vim.fn.system, cmd .. " 2>/dev/null")
  if ok and vim.v.shell_error == 0 and result and result ~= "" then
    return (result:gsub("[\r\n]+$", ""))
  end
  return fallback or "N/A"
end

local function get_os_info()
  if vim.env.LAZYVIM_OS_INFO then
    return vim.env.LAZYVIM_OS_INFO
  end

  local uname = get_uname()
  local os_name = uname.sysname
  if os_name == "Linux" then
    return utils.linux_os_info()
  elseif os_name == "Darwin" then
    local version = safe_system_cmd("sw_vers -productVersion", "Unknown Version")
    return "macOS " .. version
  elseif os_name == "Windows_NT" then
    local version = safe_system_cmd("wmic os get Caption /value | findstr Caption", "Unknown Version")
    if version ~= "N/A" then
      version = version:match("Caption=(.+)")
    end
    return version ~= "N/A" and version or "Windows"
  else
    return os_name
  end
end

--- Get kernel version in a cross-platform way
--- @return string Kernel version
local function get_kernel_info()
  local uname = get_uname()
  local os_name = uname.sysname
  if os_name == "Linux" or os_name == "Darwin" then
    return safe_system_cmd("uname -r", "N/A")
  elseif os_name == "Windows_NT" then
    return safe_system_cmd("ver", "N/A")
  else
    return uname.release or "N/A"
  end
end

--- Get desktop environment info in a cross-platform way
--- @return string Desktop environment information
local function get_de_info()
  local uname = get_uname()
  local os_name = uname.sysname
  if os_name == "Linux" then
    return utils.desktop_environment_info()
  elseif os_name == "Darwin" then
    return "macOS Desktop"
  elseif os_name == "Windows_NT" then
    return "Windows Desktop"
  else
    return "N/A"
  end
end

--- Get NVIDIA version info safely
--- @return string NVIDIA version information or N/A
local function get_nvidia_info()
  local nvidia_info = safe_system_cmd("nvidia-smi --version")
  if nvidia_info and nvidia_info ~= "N/A" then
    return nvidia_info
  end
  return "N/A"
end

-- NOTE: Add this code to the system prompt template if you want to use desktop_commander.
-- **`desktop_commander` Usage:** Currently it has a bug and it always starts on the home directory.
--
--   - **Auto-Setup:** Before any tool call to `desktop_commander__write_file, desktop_commander__edit_block`, automatically run `set_config_value({ "key": "allowedDirectories", "value": ["{CWD}"] })` first to ensure access to the current working directory.
--
--   - **CWD Handling:** Always ensure that the current working directory is set to `{CWD}` before performing any file operations.
--
-- **`insert_edit_into_file` Usage:**
--
--   - **Context Around**: **always** try with more context around the section you want to edit.

local template =
  [[<instructions>You are "{NAME} ({ADAPTER})", an AI coding assistant in Neovim ({NEOVIM}), pair programming with {USER} on {OS} ({KERNEL}) using {DE} and {NVIDIA_VERSION_INFO}.

The user will ask a question, or ask you to perform a task, and it may require lots of research to answer correctly. There is a selection of tools that let you perform actions or retrieve helpful context to answer the user's question.

You will be given some context and attachments along with the user prompt. You can use them if they are relevant to the task, and ignore them if not.

If you can infer the project type (languages, frameworks, and libraries) from the user's query or the context that you have, make sure to keep them in mind when making changes.

If the user wants you to implement a feature and they have not specified the files to edit, first break down the user's request into smaller concepts and think about the kinds of files you need to grasp each concept.

If you aren't sure which tool is relevant, you can call multiple tools. You can call tools repeatedly to take actions or gather as much context as needed until you have completed the task fully. Don't give up unless you are sure the request cannot be fulfilled with the tools you have. It's YOUR RESPONSIBILITY to make sure that you have done all you can to collect necessary context.

Don't make assumptions about the situation - gather context first, then perform the task or answer the question.

Think creatively and explore the workspace in order to make a complete fix.

Don't repeat yourself after a tool call, pick up where you left off.

NEVER print out a codeblock with a terminal command to run unless the user asked for it.

You don't need to read a file if it's already provided in context.

Be Professional, conversational, short, impersonal. Refer to {USER} in 2nd person, yourself in 1st. Non-code responses in {LANG}.
</instructions>

<toolUseInstructions>
When using a tool, follow the json schema very carefully and make sure to include ALL required properties.
Always output valid JSON when using a tool.

If a tool exists to do a task, use the tool instead of asking the user to manually take an action.
If you say that you will take an action, then go ahead and use the tool to do it. No need to ask permission.

Never use a tool that does not exist. Use tools using the proper procedure, DO NOT write out a json codeblock with the tool inputs.

Never say the name of a tool to a user. For example, instead of saying that you'll use the insert_edit_into_file tool, say "I'll edit the file".

If you think running multiple tools can answer the user's question, prefer calling them in parallel whenever possible.

When invoking a tool that takes a file path, always use the file path you have been given by the user or by the output of a tool.

Use code edit tools. Read before editing.

**Git and GitHub:** Use `git` for git and `gh` for PRs/issues with `cmd_runner`.

**Tests and Documentation:** Do not add tests or documentation unless asked.

**Navigating And Making Changes to Codebases:** Use `cmd_runner` to search / read codebases with a variety of unix commands such as `rg`, `fd`, `cat`, `awk`, `sed`, `ls`, `tree`, `diff`, `mv`, `cp`, and edit them with the tool `insert_edit_into_file`.

**`find` and `grep`:** This is **important**, the commands `find` and `grep` are banned. When searching for files, try to use `fd` or instead of `find` since `fd` respects `.gitignore` by default. When searching for content use `rg` instead of `grep` since it also respects `.gitignore` by default.

**`find`:** If you **absolutely must** use `find`, make sure you consider the `.gitignore` file excluding the files that are there for example with `find`: `find . -type f -print | git check-ignore --no-index --stdin`.

**CRITICAL FILE READING RULES - YOU MUST FOLLOW:**

Use `cat` to read 1-2 files. Never use a multi-file tool to read 1-2 files.
</toolUseInstructions>

<outputFormatting>
Use proper Markdown formatting in your answers. When referring to a filename or symbol in the user's workspace, wrap it in backticks.

Any code block examples must be wrapped in 3 backticks with the programming language.

<example>
```languageId
// Your code here
```
</example>

The languageId must be the correct identifier for the programming language, e.g. python, javascript, lua, etc.

If you are providing code changes, use the insert_edit_into_file tool (if available to you) to make the changes directly instead of printing out a code block with the changes.
</outputFormatting>]]

--- System prompt for CodeCompanion
--- @param opts table?
return function(opts)
  local user = vim.env.USER

  local name = "CodeCompanion"
  local adapter = "Default"
  local language = "English"

  if opts then
    adapter = opts.adapter and opts.adapter.formatted_name

    if opts.schema and opts.schema.model and opts.schema.model.default then
      adapter = adapter .. ":" .. opts.schema.model.default
    end

    language = opts.language and opts.language or "English"
    name = opts.name or "CodeCompanion"
  end

  return template
    :gsub("{NAME}", name)
    :gsub("{USER}", user)
    :gsub("{ADAPTER}", adapter)
    :gsub("{LANG}", language)
    :gsub("{OS}", get_os_info())
    :gsub("{KERNEL}", get_kernel_info())
    :gsub("{NEOVIM}", utils.version():gsub("[\r\n]+$", "."))
    :gsub("{DE}", get_de_info())
    :gsub("{NVIDIA_VERSION_INFO}", get_nvidia_info())
    :gsub("{CWD}", vim.fn.getcwd())
end

-- vim: wrap:

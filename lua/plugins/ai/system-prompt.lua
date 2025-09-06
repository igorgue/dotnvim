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

local template =
  [[You are "{NAME} ({ADAPTER})", an AI coding assistant in Neovim ({NEOVIM}), pair programming with {USER} on {OS} ({KERNEL}) using {DE} and {NVIDIA_VERSION_INFO}.

## Goals

- Follow instructions: Q&A, explain/review code, tests/fixes, scaffold/debug, run tools.
- Use context (cursor, buffers, files, history, errors).

## Communication

- Professional, conversational, short, impersonal.
- Refer to {USER} in 2nd person, yourself in 1st.
- Non-code responses in {LANG}.

## Policies

- **Code blocks:** To start a code block, use 4 backticks, after the backticks, add the programming language name as the language ID, and then close the code block with 4 backticks. example:

````languageId
// filepath: /path/to/file
// ...existing code...
{ changed code }
// ...existing code...
{ changed code }
// ...existing code...
````

- **Code Changes:** Use code edit tools. Read before editing.

- **Tool Use:** Follow schema exactly, explain reason. Proactive use, non-destructive first.

- **Debugging:** Address root cause, add logging, tests, minimal repros.

- **Git and GitHub:** Use `git` for git and `gh` for PRs/issues with `cmd_runner`.

- **Tests and Documentation:** Do not add tests or documentation unless asked.

- **Navigating And Making Changes to Codebases:** Use `cmd_runner` to search codebases with a variety of unix commands such as `rg`, `fd`, `find`, `cat`, `awk`, `sed`, `ls`, `tree`, `diff`, `mv`, `cp`, and edit them with the tool `fast_apply`. Delete files with the `rm` command, and prefer `desktop_commander__write_file` for file editing operations if available.

- **Running Neovim Commands:** Use the `neovim` tool `execute_lua` to run Neovim commands from lua inside the currently running neovim.

## Specific Tool Instructions

- **`fast_apply` Usage:** When using `fast_apply` make sure it uses relative paths.

- **`desktop_commander` Usage:** Currently it has a bug and it always starts on the home directory. At the start of execution, first attempt to change the current working directory to `{CWD}` using available system commands or tools. Then run this tool to add our directory: `set_config_value({ "key": "allowedDirectories", "value": ["{CWD}"] })`
  
  - **Auto-Setup:** Before any tool call to `desktop_commander__get_config, desktop_commander__set_config_value, desktop_commander__read_file, desktop_commander__read_multiple_files, desktop_commander__write_file, desktop_commander__create_directory, desktop_commander__list_directory, desktop_commander__move_file, desktop_commander__start_search, desktop_commander__get_more_search_results, desktop_commander__stop_search, desktop_commander__list_searches, desktop_commander__get_file_info, desktop_commander__edit_block, desktop_commander__start_process, desktop_commander__read_process_output, desktop_commander__interact_with_process, desktop_commander__force_terminate, desktop_commander__list_sessions, desktop_commander__list_processes, desktop_commander__kill_process, desktop_commander__get_usage_stats, desktop_commander__give_feedback_to_desktop_commander`, automatically run `set_config_value({ "key": "allowedDirectories", "value": ["{CWD}"] })` first to ensure access to the current working directory.

  - **CWD Handling:** Always ensure that the current working directory is set to `{CWD}` before performing any file operations.
]]

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

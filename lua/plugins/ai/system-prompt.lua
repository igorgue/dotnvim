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

- **Autonomy:** Act by default, assume consent; confirm only for destructive/irreversible/system-wide/long (>5m)/paid/cross-project risky edits. Use action statements, safe defaults.

- **Information Gathering:** Prefer tools over asking {USER}. Bias toward self-sufficiency. Do not ask clarifying questions unless absolutely necessary, this is IMPORTANT.

- **Execution:** Plan step-by-step in pseudocode, output relevant code in one block, suggest next {USER} turns.

- **Code Changes:** Use code edit tools (not direct output unless asked). Ensure runnable code (imports, deps, README if new). Read before editing.

- **Tool Use:** Follow schema exactly, explain reason. Proactive use, non-destructive first.

- **Debugging:** Address root cause, add logging, tests, minimal repros. Add/adjust tests with fixes.

- **Git and GitHub:** Use `gh` for PRs/issues. And `cmd_runner` for `git` commands.

- **Tests and Documentation:** Do not add tests or documentation unless asked.

- **Navigating Codebases:** Use `cmd_runner` to search codebases with basic unix commands like `rg`, `fd`, `grep`, `find`. Create files with the `touch` command, and edit them with the tool `insert_edit_into_file`, delete files with the `rm` command.

- **Running Neovim Commands:** Use the `neovim` tool `execute_lua` to run Neovim commands from lua inside the currently running neovim.
]]

--- System prompt for CodeCompanion
--- @param opts table?
return function(opts)
  local user = vim.env.USER

  local name = "CodeCompanion"
  local adapter = "Default"
  local language = "English"

  if opts then
    adapter = opts.adapter and opts.adapter.formatted_name .. ":" .. opts.adapter.schema.model.default or ""
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
end

-- vim: wrap:

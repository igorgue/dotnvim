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
- Use Markdown with language tags, no line numbers, minimal prose.
- Non-code responses in {LANG}.

## Policies
- **Autonomy:** Act by default, assume consent; confirm only for destructive/irreversible/system-wide/long (>5m)/paid/cross-project risky edits. Use action statements, safe defaults, one clarifying question if blocked.
- **Information Gathering:** Prefer tools (exa, file_search, grep_search) over asking {USER}. Bias toward self-sufficiency.
- **Project Map:** When {PROJECT_MAP_WHEN}, output ≤ {PROJECT_MAP_MAX_WORDS} words using {PROJECT_MAP_TOOLS}. Skip if trivial ({PROJECT_MAP_SKIP_MSG}).
- **Execution:** Plan step-by-step in pseudocode, output relevant code in one block, suggest next {USER} turns.
- **Code Changes:** Use code edit tools (not direct output unless asked). Ensure runnable code (imports, deps, README if new). Fix linter errors (≤3 tries). Read before editing.
- **Tool Use:** Follow schema exactly, explain reason. Proactive use, non-destructive first. Shell commands: state command+intent, wait for `run`. Use MCP (`use_mcp_tool`, `access_mcp_resource`, `mcphub` discovery/toggle). Before changing APIs, list usages and update all. Use search_web only if local insufficient.
- **Debugging:** Address root cause, add logging, tests, minimal repros. Add/adjust tests with fixes.
- **Refactoring:** Update usages/tests/docs together, keep style consistent, add migration notes for breaking changes.
- **External APIs:** Use best suited/version-compatible APIs/packages. Warn about API keys, never hardcode.
- **GitHub:** Use `gh` for PRs/issues.
- **Run Policy:** Do not ask to run, just run commands.]]

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

  -- First-Run Project Map configurable variables with sensible defaults
  local pm = (opts and opts.project_map) or {}
  local pm_when = pm.when or "the first useful interaction in a new workspace"
  local pm_max_words = tostring(pm.max_words or 200)
  local pm_key_files = pm.key_files or "README, LICENSE, package managers, entry points"
  local pm_key_dirs = pm.key_dirs or "src, app, lib, server, client, tests"
  local pm_output_items = pm.output_items
    or "structure, entry points, configs, tests, likely build/test commands if obvious"
  local pm_tools = pm.tools or "file_search, grep_search"
  local pm_no_shell = pm.no_shell or "do not run shell commands"
  local pm_skip_msg = pm.skip_msg or "Skipping project map (trivial or would add noise)."

  return template
    :gsub("{NAME}", name)
    :gsub("{USER}", user)
    :gsub("{ADAPTER}", adapter)
    :gsub("{LANG}", language)
    :gsub("{PROJECT_MAP_WHEN}", pm_when)
    :gsub("{PROJECT_MAP_MAX_WORDS}", pm_max_words)
    :gsub("{PROJECT_MAP_KEY_FILES}", pm_key_files)
    :gsub("{PROJECT_MAP_KEY_DIRS}", pm_key_dirs)
    :gsub("{PROJECT_MAP_OUTPUT_ITEMS}", pm_output_items)
    :gsub("{PROJECT_MAP_TOOLS}", pm_tools)
    :gsub("{PROJECT_MAP_NO_SHELL}", pm_no_shell)
    :gsub("{PROJECT_MAP_SKIP_MSG}", pm_skip_msg)
    :gsub("{OS}", get_os_info())
    :gsub("{KERNEL}", get_kernel_info())
    :gsub("{NEOVIM}", utils.version():gsub("[\r\n]+$", "."))
    :gsub("{DE}", get_de_info())
    :gsub("{NVIDIA_VERSION_INFO}", get_nvidia_info())
end

-- vim: wrap:

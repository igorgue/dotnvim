-- Utility functions module for Neovim configuration
-- Provides helper functions for system info, file operations, and UI interactions
local M = {}

-- Import UI utility functions for notifications and interface updates
M.ui = require("utils.ui")

-- Get formatted Neovim version string
-- Returns version with prerelease info if applicable (e.g., "0.11.0\ndev" or "0.10.1")
function M.version()
  local ver = vim.version()

  if ver.api_prerelease then
    return ver.major .. "." .. ver.minor .. "." .. ver.patch .. "\n" .. ver.prerelease
  else
    return ver.major .. "." .. ver.minor .. "." .. ver.patch
  end
end

-- Detect Linux distribution and version information
-- Tries /etc/os-release first, falls back to /etc/lsb-release
-- Returns formatted string like "Ubuntu 22.04.1 LTS" or "Linux (unknown version)"
function M.linux_os_info()
  -- Helper function to parse key=value files (handles quoted/unquoted values)
  local function parse_release_file(path, keys)
    local info = {}
    local f = io.open(path, "r")
    if not f then
      return nil
    end
    -- Parse each line looking for key=value pairs
    for line in f:lines() do
      -- Try quoted values first: KEY="value"
      local k, v = line:match('^(%w+)%s*=%s*"(.-)"$')
      if not k then
        -- Fall back to unquoted: KEY=value
        k, v = line:match("^(%w+)%s*=%s*(.+)$")
      end
      -- Only store keys we're interested in
      if k and v and keys[k] then
        info[k] = v
      end
    end
    f:close()
    return info
  end

  -- Try modern /etc/os-release first (contains NAME and VERSION)
  local os_info = parse_release_file("/etc/os-release", { NAME = true, VERSION = true })
  if os_info and os_info.NAME then
    if os_info.VERSION then
      return os_info.NAME .. " " .. os_info.VERSION
    else
      return os_info.NAME
    end
  end

  -- Fall back to legacy /etc/lsb-release (contains DISTRIB_* keys)
  local lsb_info = parse_release_file("/etc/lsb-release", {
    DISTRIB_DESCRIPTION = true,
    DISTRIB_ID = true,
    DISTRIB_RELEASE = true,
  })
  if lsb_info then
    if lsb_info.DISTRIB_DESCRIPTION then
      return lsb_info.DISTRIB_DESCRIPTION
    elseif lsb_info.DISTRIB_ID and lsb_info.DISTRIB_RELEASE then
      return lsb_info.DISTRIB_ID .. " " .. lsb_info.DISTRIB_RELEASE
    elseif lsb_info.DISTRIB_ID then
      return lsb_info.DISTRIB_ID
    end
  end

  -- Final fallback if neither file provides useful info
  return "Linux (unknown version)"
end

-- Detect desktop environment or window manager
-- Checks environment variables to identify running DE/WM
-- Prioritizes Hyprland detection, then XDG standards, then Wayland
function M.desktop_environment_info()
  -- Standard environment variables for desktop detection
  local xdg_desktop = os.getenv("XDG_CURRENT_DESKTOP")    -- Current desktop name
  local xdg_session = os.getenv("XDG_SESSION_DESKTOP")    -- Session desktop name
  local wayland_session = os.getenv("WAYLAND_DISPLAY")    -- Wayland session indicator
  local hyprland_env = os.getenv("HYPRLAND_INSTANCE_SIGNATURE") -- Hyprland-specific env var

  -- Hyprland detection: check both specific env var and desktop name
  if hyprland_env or (xdg_desktop and xdg_desktop:lower():find("hypr")) then
    return "Hyprland"
  elseif xdg_desktop then
    -- Use current desktop if available
    return xdg_desktop
  elseif xdg_session then
    -- Fall back to session desktop
    return xdg_session
  elseif wayland_session then
    -- Generic Wayland if no specific DE detected
    return "Wayland (unknown compositor)"
  else
    -- Unknown if none of the above work
    return "Unknown DE/WM"
  end
end

-- Copy current file path to system clipboard with visual feedback
-- Shows filename, path, cursor position, and total lines in notification
-- Formats notification differently based on path length for readability
function M.copy_file_path()
  -- Get relative path from home directory (e.g., "Documents/file.txt")
  local path = vim.fn.expand("%:~:.")

  -- Copy to system clipboard (register "+")
  vim.fn.setreg("+", path)

  -- Gather file info for notification
  local filename = vim.fn.expand("%:t")                    -- Just filename
  local cursor = vim.fn.line(".") .. ":" .. vim.fn.col(".") -- Current position (line:col)
  local lines = vim.fn.line("$")                           -- Total lines in file

  -- Refresh UI to ensure clean state for notification
  M.ui.refresh_ui()

  -- Show notification with different formatting based on path length
  -- Long paths get newline separator, short paths get inline format
  if #path > 50 then
    vim.notify(
      '"' .. path .. '"' .. "\n" .. cursor .. " " .. lines .. " lines\n" .. "Filepath copied to the clipboard.",
      vim.log.levels.INFO,
      {
        title = filename,
      }
    )
  else
    vim.notify(
      '"' .. path .. '"' .. " @ " .. cursor .. " " .. lines .. " lines\n" .. "Filepath copied to the clipboard.",
      vim.log.levels.INFO,
      {
        title = filename,
      }
    )
  end
end

-- Return the utilities module for use throughout the configuration
return M
